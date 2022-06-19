#include <cstdio>
#include <iostream>
#include <chrono>
#include <thread>
#include <vector>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>

using namespace std;

__constant__ int RACE_DISTANCE = 100;
__constant__ int MAX_SPEED = 5;

class Runner {
    private:
        int position;
        int speed;
        int index;

    public:
        void init(int index){
            this->position = 0;
            this->speed = 0;
            this->index = index;
        }

        void setSpeed(int speed){
            this->speed = speed;
        }

        __device__ void increasePosition(){
            if(this->position >= RACE_DISTANCE){
                this->position += MAX_SPEED;
                return;
            }
            this->position += this->speed;
        }

        __device__ __host__ int getPosition() const{
            return this->position;
        }

        int getIndex(){
            return this->index;
        }
};


__host__ __device__ bool operator<(const Runner &o1, const Runner &o2) 
{
   return o1.getPosition() > o2.getPosition();
}

__global__ void calculate_race_positions(
    Runner * d_runners,
    bool *is_any_finish,
    bool *is_any_racing
) {
    d_runners[threadIdx.x].increasePosition();

    if( d_runners[threadIdx.x].getPosition() >= RACE_DISTANCE ){
        *is_any_finish = true;
    }else{
        *is_any_racing = true;
    }
}

class RaceService{
    private:
        bool *d_is_any_finish, *d_is_any_racing;
        bool is_any_finish;
        bool is_any_racing;
        bool is_finish_printed;

        int participant_count;
        int required_mem_size;

        Runner *runners;
        Runner *d_runners;

        void fillSpeedsRandom(int size){
            for(int i = 0; i < size; i++){
                this->runners[i].setSpeed(1 + (rand() % 5));
            }
        }

        void randomizeVelocities(){
            fillSpeedsRandom(this->participant_count);
        }

    public:
        void init(int number_of_contestants){
            this->participant_count = number_of_contestants;
            this->required_mem_size = sizeof(Runner) * number_of_contestants;
            this->runners = (Runner *)malloc(this->required_mem_size);

            for(int i = 0; i < this->participant_count; i++){
                this->runners[i].init(i+1);
            }

            this->presetFlags();
            this->is_finish_printed = false;

            cudaMalloc((void **)&d_runners, this->required_mem_size);

            cudaMalloc((void **)&d_is_any_finish, sizeof(bool));
            cudaMalloc((void **)&d_is_any_racing, sizeof(bool));
        }

        void presetFlags(){
            this->is_any_finish = false;
            this->is_any_racing = false;
        }

        void cleanup(){
            free(this->runners);
            cudaFree(d_runners); cudaFree(d_is_any_finish); cudaFree(d_is_any_racing);
        }

        void printPositions(){
            cout << "Bitiş çizgisine ilk koşucu ulaştı." << endl;
            for(int i = 0; i < this->participant_count; i++){
                int position = this->runners[i].getPosition();
                if(position >= 100){
                    position = 100;
                }
                cout << i+1 << "- " << position << ". metrede" << endl;
            }
            cout << "########### YARIŞ BİTTİ ###########" << endl;
        }

        void printIndexes(thrust::host_vector<Runner> h_runners){
            for(int i=0; i < h_runners.size(); i++)
                cout << i+1 << ". :" << h_runners[i].getIndex() << " Numarali Kosucu " << endl;
            cout << endl;
        }

        void move_to_next_position(){
            this->randomizeVelocities();
            this-> presetFlags();

            cudaMemcpy(
                d_runners,
                runners,
                required_mem_size,
                cudaMemcpyHostToDevice
            );
            cudaMemcpy(
                d_is_any_finish,
                &is_any_finish,
                sizeof(bool),
                cudaMemcpyHostToDevice
            );
            cudaMemcpy(
                d_is_any_racing,
                &is_any_racing,
                sizeof(bool),
                cudaMemcpyHostToDevice
            );

            calculate_race_positions<<<1, this->participant_count>>>(
                d_runners,
                d_is_any_finish,
                d_is_any_racing
            );

            cudaMemcpy(
                &is_any_finish,
                d_is_any_finish,
                sizeof(bool),
                cudaMemcpyDeviceToHost
            );
            cudaMemcpy(
                &is_any_racing,
                d_is_any_racing,
                sizeof(bool),
                cudaMemcpyDeviceToHost
            );
            cudaMemcpy(
                runners,
                d_runners,
                required_mem_size,
                cudaMemcpyDeviceToHost
            );
        }

        void sort_positions(){
            thrust::device_vector<Runner> cd;
            thrust::host_vector<Runner> ch;
            for(int i = 0; i < this->participant_count; i++){
                ch.push_back(this->runners[i]);
            }
            cd = ch;
            thrust::sort(cd.begin(), cd.end());
            ch = cd;
            printIndexes(ch);
        }

        void start(){
            while (true){
                move_to_next_position();
                if(this->is_any_finish && !this->is_finish_printed){
                    printPositions();
                    this->is_finish_printed = true;
                }
                if(!this->is_any_racing){
                    sort_positions();
                    break;
                }
                this_thread::sleep_for(chrono::milliseconds(1000));
            }
        }
};

int main(void){
    RaceService race;
    race.init(100);
    race.start();
    race.cleanup();
}
