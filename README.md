## Getting Started

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

This a playground project for paralel programing with cuda.

Request -> 
```
    Calculate a race with 100 participants in parallel -> 
    Speeds of participants are given randomly between 1 and 5 ->
    run calculations once in a second ->
    print all participant positions when there is a winner ->
    after race ended give participant order
```
Decisions ->
```
    - Every second all participants speed is added to position
    - After a participant reaches finish line in order keep ordering correct 
      MAX_SPEED added to its position
    - There is 2 flags to check if race is still going and to check if there is 
      anyone that already finished it( to reduce calculation count on cpu side)
    - after race ended participant positions ordered and final results are 
      calculated.
```
<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started


### Prerequisites

#### Local
* [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)
* [GCC](https://gcc.gnu.org/)
#### Via Colab
* Any Browser

### Setup

#### With google colab

- [Referance](https://www.geeksforgeeks.org/how-to-run-cuda-c-c-on-jupyter-notebook-in-google-colaboratory/)
```
- Open https://colab.research.google.com
- Runtime -> Change Runtime Type -> Change to 'GPU' -> Save
- Run  !nvcc --version
- Run  !pip install git+https://github.com/andreinechaev/nvcc4jupyter.git
- Run %load_ext nvcc_plugin
- add %%cu at the beginning of code and you can paste cpp code
```
<p align="right">(<a href="#top">back to top</a>)</p>
