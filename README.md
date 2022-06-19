## Getting Started


<div id="top"></div>

[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">Food Order</h3>

</div>



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
    Calculate a race with 100 participants in paralel -> 
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
* [Any Browser](#)

### Setup

#### With google colab

- [Referance](https://www.geeksforgeeks.org/how-to-run-cuda-c-c-on-jupyter-notebook-in-google-colaboratory/)
```
- Open https://colab.research.google.com
- Runtime -> Change Runtime Type -> Change to 'GPU' -> Save
- Run  !nvcc --version
- Run  !pip install git+https://github.com/andreinechaev/nvcc4jupyter.
- Run %load_ext nvcc_plugin
- add %%cu at the beginning of code and you can paste cpp code
```

#### With Nvcc
```
# Check gcc version
$ gcc --version
$ g++ --version
gcc (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0

# Check gcc version
$ nvcc --version
Built on Mon_Oct_12_20:09:46_PDT_2020
Cuda compilation tools, release 11.1, V11.1.105
Build cuda_11.1.TC455_06.29190527_0

```

<p align="right">(<a href="#top">back to top</a>)</p>
