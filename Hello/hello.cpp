#include <stdio.h>
#include <omp.h>
#ifdef HPXC
#include <hpx/hpx_main.hpp>
#endif // HPXC
int main(int argc, char** argv){
	//omp_set_num_threads(4);
	#pragma omp parallel
	{
		printf("Hwllo %d\n", omp_get_thread_num());
	}

    return 0;
}
