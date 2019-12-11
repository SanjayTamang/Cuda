#include <stdio.h>
#include <cuda_runtime_api.h>
#include <time.h>
/****************************************************************************
  This program gives an example of a poor way to implement a password cracker
  in CUDA C. It is poor because it acheives this with just one thread, which
  is obviously not good given the scale of parallelism available to CUDA
  programs.
  
  The intentions of this program are:
    1) Demonstrate the use of __device__ and __global__ functions
    2) Enable a simulation of password cracking in the absence of library 
       with equivalent functionality to libcrypt. The password to be found
       is hardcoded into a function called is_a_match.   

  Compile and run with:
    nvcc -o cuda_passwordcracking cuda_passwordcracking.cu
    ./cuda_passwordcracking
   
  Dr Kevan Buckley, University of Wolverhampton, 2018
*****************************************************************************/

/****************************************************************************
  This function returns 1 if the attempt at cracking the password is 
  identical to the plain text password string stored in the program. 
  Otherwise,it returns 0.
*****************************************************************************/

__device__ int is_a_match(char *attempt) {
  char plain_password1[] = "SA1234";
  char plain_password2[] = "NJ5674";
  char plain_password3[] = "AY2345";
  char plain_password4[] = "TA4567";


  char *x = attempt;
  char *y = attempt;
  char *z = attempt;
  char *a = attempt;
  char *plain1 = plain_password1;
  char *plain2 = plain_password2;
  char *plain3 = plain_password3;
  char *plain4 = plain_password4;

  while(*x == *plain1) { 
   if(*x == '\0') 
    {
	printf("Password found is: %s\n",plain_password1);
      break;
    }

    x++;
    plain1++;
  }
	
  while(*y == *plain2) { 
   if(*y == '\0') 
    {
	printf("Password found is: %s\n",plain_password2);
      break;
    }

    y++;
    plain2++;
  }

  while(*z == *plain3) { 
   if(*z == '\0') 
    {
	printf("Password found is: %s\n",plain_password3);
      break;
    }

    z++;
    plain3++;
  }

  while(*a == *plain4) { 
   if(*a == '\0') 
    {
	printf("Password found is: %s\n",plain_password4);
      return 1;
    }

    a++;
    plain4++;
  }
  return 0;

}


__global__ void  kernel() {
char b,c,d,e;
  
  char password[7];
  password[6] = '\0';

int i = blockIdx.x+65;
int j = threadIdx.x+65;
char firstValue = i; 
char secondValue = j; 
    
password[0] = firstValue;
password[1] = secondValue;
	for(b='0'; b<='9'; b++){
	  for(c='0'; c<='9'; c++){
	   for(d='0'; d<='9'; d++){
	     for(e='0'; e<='9'; e++){
	        password[2] = b;
	        password[3] = c;
	        password[4] = d;
	        password[5] = e; 
	      if(is_a_match(password)) {
		
	      } 
             else {
	     	  
	      }
	   }
	}
	}
	}

}

int time_difference(struct timespec *start, 
                    struct timespec *finish, 
                    long long int *difference) {
  long long int ds =  finish->tv_sec - start->tv_sec; 
  long long int dn =  finish->tv_nsec - start->tv_nsec; 

  if(dn < 0 ) {
    ds--;
    dn += 1000000000; 
  } 
  *difference = ds * 1000000000 + dn;
  return !(*difference > 0);
}


int main() {

  struct  timespec start, finish;
  long long int time_elapsed;
  clock_gettime(CLOCK_MONOTONIC, &start);

  kernel <<<26,26>>>();
  cudaThreadSynchronize();

  clock_gettime(CLOCK_MONOTONIC, &finish);
  time_difference(&start, &finish, &time_elapsed);
  printf("Time elapsed was %lldns or %0.9lfs\n", time_elapsed, (time_elapsed/1.0e9)); 

  return 0;
}


