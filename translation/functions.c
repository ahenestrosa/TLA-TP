#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define NELEMS(x)  (sizeof(x) / sizeof((x)[0]))

// ------------------------- DEFINITIONS -------------------------

typedef struct IntArr{
	int * arr;
	int size;
	int * (*on_access)(struct IntArr *, int);
} IntArr;

typedef struct DoubleArr{
	double * arr;
	int size;
	double * (*on_access)(struct DoubleArr *, int);
} DoubleArr;

int * _check_int_index(struct IntArr * arr, int i){
    if (i >= 0 && i < arr->size){
        return arr->arr + i;
    } else {
        fprintf(stderr, "\033[0;31m");
        printf("Array index out of bounds\n");
        fprintf(stderr, "\033[0m");
        exit(0);
        return NULL;
    }
}

double * _check_double_index(struct DoubleArr * arr, int i){
    if (i >= 0 && i < arr->size){
        return arr->arr + i;
    } else {
        fprintf(stderr, "\033[0;31m");
        printf("Array index out of bounds\n");
        fprintf(stderr, "\033[0m");
        exit(0);
        return NULL;
    }
}

void _div_0_error(){
	fprintf(stderr, "\033[0;31m");
	printf("Division by zero\n");
	fprintf(stderr, "\033[0m");
	exit(0);
}

// ---------- Product ----------

// Product Int Arr & Int
IntArr * _prodIntArrInt(IntArr * arr, int num);
IntArr * _prodIntIntArr(int num, IntArr * arr);

// Product Int Arr & Double
DoubleArr * _prodIntArrDouble(IntArr * arr, double num);
DoubleArr * _prodDoubleIntArr(double num, IntArr * arr);

// Product Double Arr & Double
DoubleArr * _prodDoubleArrDouble(DoubleArr * arr, double num);
DoubleArr * _prodDoubleDoubleArr(double num, DoubleArr * arr);

// Product Double Arr & Int
DoubleArr * _prodDoubleArrInt(DoubleArr * arr, int num);
DoubleArr * _prodIntDoubleArr(int num, DoubleArr * arr);

// Product Double Arr & Double Arr
DoubleArr * _prodDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2);

// Product Int Arr & Int Arr
IntArr * _prodIntArrIntArr(IntArr * arr1, IntArr * arr2);

// Product Int Arr & Double Arr
DoubleArr * _prodDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2);
DoubleArr * _prodIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);

// ---------- Sum ----------

// Sum Int Arr & Int
IntArr * _sumIntArrInt(IntArr * arr, int num);
IntArr * _sumIntIntArr(int num, IntArr * arr);

// Sum Int Arr & Double
DoubleArr * _sumIntArrDouble(IntArr * arr, double num);
DoubleArr * _sumDoubleIntArr(double num, IntArr * arr);

// Sum Double Arr & Double
DoubleArr * _sumDoubleArrDouble(DoubleArr * arr, double num);
DoubleArr * _sumDoubleDoubleArr(double num, DoubleArr * arr);

// Sum Double Arr & Int
DoubleArr * _sumDoubleArrInt(DoubleArr * arr, int num);
DoubleArr * _sumIntDoubleArr(int num, DoubleArr * arr);

// Sum Double Arr & Double Arr
DoubleArr * _sumDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2);

// Sum Int Arr & Int Arr
IntArr * _sumIntArrIntArr(IntArr * arr1, IntArr * arr2);

// Sum Int Arr & Double Arr
DoubleArr * _sumDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2);
DoubleArr * _sumIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);

// Sum Str & Str
char * _sumStrStr(char * str1, char * str2);

// ---------- Subs ----------

// Subs Int Arr & Int
IntArr * _subsIntArrInt(IntArr * arr, int num);

// Subs Int Arr & Double
DoubleArr * _subsIntArrDouble(IntArr * arr, double num);

// Subs Double Arr & Double
DoubleArr * _subsDoubleArrDouble(DoubleArr * arr, double num);

// Subs Double Arr & Int
DoubleArr * _subsDoubleArrInt(DoubleArr * arr, int num);

// Subs Double Arr & Double Arr
DoubleArr * _subsDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2);

// Subs Int Arr & Int Arr
IntArr * _subsIntArrIntArr(IntArr * arr1, IntArr * arr2);

// Subs Int Arr & Double Arr
DoubleArr * _subsDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2);
DoubleArr * _subsIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);

// ---------- Div ----------

// Div Int Arr & Int
DoubleArr * _divIntArrInt(IntArr * arr, int num);

// Div Int Arr & Double
DoubleArr * _divIntArrDouble(IntArr * arr, double num);

// Div Double Arr & Double
DoubleArr * _divDoubleArrDouble(DoubleArr * arr, double num);

// Div Double Arr & Int
DoubleArr * _divDoubleArrInt(DoubleArr * arr, int num);

// Div Double Arr & Double Arr
DoubleArr * _divDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2);

// Div Int Arr & Int Arr
DoubleArr * _divIntArrIntArr(IntArr * arr1, IntArr * arr2);

// Div Int Arr & Double Arr
DoubleArr * _divDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2);
DoubleArr * _divIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);

//----------- Cross ----------

IntArr * _crossIntArrIntArr(IntArr * arr1, IntArr * arr2);
DoubleArr * _crossIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);
DoubleArr * _crossDoubleArrIntArr(DoubleArr *arr1, IntArr * arr2);
DoubleArr * _crossDoubleArrDoubleArr(DoubleArr *arr1, DoubleArr * arr2);


//------------- Scalar Prod -------------------
int _sprodIntArrIntArr(IntArr * arr1, IntArr * arr2);
double _sprodDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2);
double _sprodIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2);
double _sprodDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2);

// ---------- Other ----------

void _printIntArr(IntArr * arr);
void _printDoubleArr(DoubleArr * arr);

int _checkArrSizes(int s1, int s2);

// ---------- Input ----------

int _getInt();
char * _getString();
double _getDouble();


// ------------------------- IMPLEMENTATIONS -------------------------

// ---------- Product ----------

// Product Int Arr & Int
IntArr * _prodIntArrInt(IntArr * arr, int num){
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (arr->arr[i] * num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
IntArr * _prodIntIntArr(int num, IntArr * arr){
	return _prodIntArrInt(arr, num);
}

// Product Int Arr & Double
DoubleArr * _prodIntArrDouble(IntArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] * num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _prodDoubleIntArr(double num, IntArr * arr){
	return _prodIntArrDouble(arr, num);
}

// Product Double Arr & Double
DoubleArr * _prodDoubleArrDouble(DoubleArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] * num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _prodDoubleDoubleArr(double num, DoubleArr * arr){
	return _prodDoubleArrDouble(arr, num);
}

// Product Double Arr & Int
DoubleArr * _prodDoubleArrInt(DoubleArr * arr, int num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] * num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _prodIntDoubleArr(int num, DoubleArr * arr){
	return _prodDoubleArrInt(arr, num);
}

// Product Double Arr & Double Arr
DoubleArr * _prodDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] * arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Product Int Arr & Int Arr
IntArr * _prodIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (arr1->arr[i] * arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Product Int Arr & Double Arr
DoubleArr * _prodDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] * arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}
DoubleArr * _prodIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	return _prodDoubleArrIntArr(arr2, arr1);
}

// ---------- Sum ----------

// Sum Int Arr & Int
IntArr * _sumIntArrInt(IntArr * arr, int num){
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (arr->arr[i] + num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
IntArr * _sumIntIntArr(int num, IntArr * arr){
	return _sumIntArrInt(arr, num);
}

// Sum Int Arr & Double
DoubleArr * _sumIntArrDouble(IntArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] + num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _sumDoubleIntArr(double num, IntArr * arr){
	return _sumIntArrDouble(arr, num);
}

// Sum Double Arr & Double
DoubleArr * _sumDoubleArrDouble(DoubleArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] + num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _sumDoubleDoubleArr(double num, DoubleArr * arr){
	return _sumDoubleArrDouble(arr, num);
}

// Sum Double Arr & Int
DoubleArr * _sumDoubleArrInt(DoubleArr * arr, int num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] + num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}
DoubleArr * _sumIntDoubleArr(int num, DoubleArr * arr){
	return _sumDoubleArrInt(arr, num);
}

// Sum Double Arr & Double Arr
DoubleArr * _sumDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] + arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Sum Int Arr & Int Arr
IntArr * _sumIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (arr1->arr[i] + arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Sum Int Arr & Double Arr
DoubleArr * _sumDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] + arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}
DoubleArr * _sumIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	return _sumDoubleArrIntArr(arr2, arr1);
}

// Sum Str & Str
char * _sumStrStr(char * str1, char * str2){
	char * buffer = malloc(1 + strlen(str1) + strlen(str2));
	sprintf(buffer, "%s%s", str1, str2);
	return buffer;
}

// ---------- Subs ----------

// Subs Int Arr & Int
IntArr * _subsIntArrInt(IntArr * arr, int num){
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (arr->arr[i] - num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Subs Int Arr & Double
DoubleArr * _subsIntArrDouble(IntArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] - num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Subs Double Arr & Double
DoubleArr * _subsDoubleArrDouble(DoubleArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] - num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Subs Double Arr & Int
DoubleArr * _subsDoubleArrInt(DoubleArr * arr, int num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){resArr[i] = (double)(arr->arr[i] - num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Subs Double Arr & Double Arr
DoubleArr * _subsDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] - arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Subs Int Arr & Int Arr
IntArr * _subsIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	IntArr * res = malloc(sizeof(IntArr));
	int * resArr = malloc(sizeof(int) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (arr1->arr[i] - arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Subs Int Arr & Double Arr
DoubleArr * _subsDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){resArr[i] = (double)(arr1->arr[i] - arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}
DoubleArr * _subsIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	return _subsDoubleArrIntArr(arr2, arr1);
}

// ---------- Div ----------

// Div Int Arr & Int
DoubleArr * _divIntArrInt(IntArr * arr, int num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){if (num == 0){_div_0_error();}resArr[i] = (double)(arr->arr[i] / (double)num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Div Int Arr & Double
DoubleArr * _divIntArrDouble(IntArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){if (num == 0){_div_0_error();}resArr[i] = (double)(arr->arr[i] / (double)num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Div Double Arr & Double
DoubleArr * _divDoubleArrDouble(DoubleArr * arr, double num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){if (num == 0){_div_0_error();}resArr[i] = (double)(arr->arr[i] / num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Div Double Arr & Int
DoubleArr * _divDoubleArrInt(DoubleArr * arr, int num){
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr->size);
	int i = 0;for(i = 0; i < arr->size; i++){if (num == 0){_div_0_error();}resArr[i] = (double)(arr->arr[i] / num);}
	res->arr = resArr;
	res->size = arr->size;
	return res;
}

// Div Double Arr & Double Arr
DoubleArr * _divDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){if (arr2->arr[i] == 0){_div_0_error();}resArr[i] = (double)(arr1->arr[i] / arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Div Int Arr & Int Arr
DoubleArr * _divIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){if (arr2->arr[i] == 0){_div_0_error();}resArr[i] = (double)(arr1->arr[i] / (double)arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}

// Div Int Arr & Double Arr
DoubleArr * _divDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	DoubleArr * res = malloc(sizeof(DoubleArr));
	double * resArr = malloc(sizeof(double) * arr1->size);
	int i = 0;for(i = 0; i < arr1->size; i++){if (arr2->arr[i] == 0){_div_0_error();}resArr[i] = (double)(arr1->arr[i] / (double)arr2->arr[i]);}
	res->arr = resArr;
	res->size = arr1->size;
	return res;
}
DoubleArr * _divIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	return _divDoubleArrIntArr(arr2, arr1);
}

//----------- Cross ----------

IntArr * _crossIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	if(arr1->size == 2){
		IntArr * res = malloc(sizeof(IntArr));
		int * resArr = malloc(sizeof(int) * 1);
		resArr[0] = arr1->arr[0] * arr2->arr[1] - arr1->arr[1] * arr2->arr[0];
		res->arr = resArr;
		res->size = 1;
		return res;
	}
	else if(arr1->size == 3){
		IntArr * res = malloc(sizeof(IntArr));
		int * resArr = malloc(sizeof(int) * 3);
		resArr[0] = arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		resArr[1] = -(arr1->arr[0] * arr2->arr[2] - arr1->arr[2] * arr2->arr[0]);
		resArr[2] = arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		res->arr = resArr;
		res->size = 3;
		return res;
	}
	else{
		fprintf(stderr, "Invalid size of operation between arrays");
		exit(0);
	}
}

DoubleArr * _crossIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	if(arr1->size == 2){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 1);
		resArr[0] = (double) arr1->arr[0] * arr2->arr[1] - arr1->arr[1] * arr2->arr[0];
		res->arr = resArr;
		res->size = 1;
		return res;
	}
	else if(arr1->size == 3){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 3);
		resArr[0] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		resArr[1] = -((double) arr1->arr[0] * arr2->arr[2] - arr1->arr[2] * arr2->arr[0]);
		resArr[2] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		res->arr = resArr;
		res->size = 3;
		return res;
	}
	else{
		fprintf(stderr, "Invalid size of operation between arrays");
		exit(0);
	}
}

DoubleArr * _crossDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	if(arr1->size == 2){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 1);
		resArr[0] = (double) arr1->arr[0] * arr2->arr[1] - arr1->arr[1] * arr2->arr[0];
		res->arr = resArr;
		res->size = 1;
		return res;
	}
	else if(arr1->size == 3){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 3);
		resArr[0] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		resArr[1] = -((double) arr1->arr[0] * arr2->arr[2] - arr1->arr[2] * arr2->arr[0]);
		resArr[2] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		res->arr = resArr;
		res->size = 3;
		return res;
	}
	else{
		fprintf(stderr, "Invalid size of operation between arrays");
		exit(0);
	}
}

DoubleArr * _crossDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	if(arr1->size == 2){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 1);
		resArr[0] = (double) arr1->arr[0] * arr2->arr[1] - arr1->arr[1] * arr2->arr[0];
		res->arr = resArr;
		res->size = 1;
		return res;
	}
	else if(arr1->size == 3){
		DoubleArr * res = malloc(sizeof(DoubleArr));
		double * resArr = malloc(sizeof(double) * 3);
		resArr[0] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		resArr[1] = -((double) arr1->arr[0] * arr2->arr[2] - arr1->arr[2] * arr2->arr[0]);
		resArr[2] = (double) arr1->arr[1] * arr2->arr[2] - arr1->arr[2] * arr2->arr[1];
		res->arr = resArr;
		res->size = 3;
		return res;
	}
	else{
		fprintf(stderr, "Invalid size of operation between arrays");
		exit(0);
	}
}


//Scalar product

 int _sprodIntArrIntArr(IntArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1 -> size, arr2 -> size);
	int res = 0, i;
	for(i = 0; i < arr1 -> size; i++){
		res += (arr1 -> arr[i] * arr2 -> arr[i] );
	} 
	return res; 
} 

double _sprodDoubleArrIntArr(DoubleArr * arr1, IntArr * arr2){
	_checkArrSizes(arr1->size, arr2->size);
	double res=0;
	int i;
	for(i = 0; i<arr1->size; i++){
		res += (arr1->arr[i] * ((double)arr2->arr[i]));
	}
	return res;
} 
	
double _sprodIntArrDoubleArr(IntArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1 -> size, arr2 -> size);
	double res=0;
	int i;
	for(i = 0; i<arr1->size; i++){
		res += (((double) arr1->arr[i]) * arr2 -> arr[i] );
	} return res;
}

double _sprodDoubleArrDoubleArr(DoubleArr * arr1, DoubleArr * arr2){
	_checkArrSizes(arr1 -> size, arr2 -> size);
	double res=0;
	int i;
	for(i = 0; i <arr1->size;i++){
		res+= arr1->arr[i] * arr2->arr[i];
	} 
	return res; 
}



// ---------- Other ----------

void _printIntArr(IntArr * arr){
	int i = 0;
	printf("[");
	for (i = 0; i < arr->size; i++){
		if (i == arr->size - 1){
			printf("%d]\n", arr->arr[i]);
		} else {
			printf("%d ", arr->arr[i]);
		}
	}
}

void _printDoubleArr(DoubleArr * arr){
	int i = 0;
	printf("[");
	for (i = 0; i < arr->size; i++){
		if (i == arr->size - 1){
			printf("%f]\n", arr->arr[i]);
		} else {
			printf("%f ", arr->arr[i]);
		}
	}
}

int _checkArrSizes(int s1, int s2){
	if(s1 != s2){
		fprintf(stderr, "Invalid size of operation between arrays");
		exit(0);
	}

	return 0;
}

// ---------- Input ----------

int _getInt(){
    char c;
    char num_buff[12] = {0};
    int index = 0;
    while ((c = getchar()) != EOF && c != '\n'){
        if (c == '-' && index == 0){
            num_buff[index++] = c;
        } else if (c >= '0' && c <= '9'){
            if (index < 12){
                num_buff[index++] = c;
            } else {
                fprintf(stderr, "\033[0;31m");
                printf("Number out of range\n");
                fprintf(stderr, "\033[0m");
                exit(1);
            }
        } else {
            fprintf(stderr, "\033[0;31m");
            printf("Not a number\n");
            fprintf(stderr, "\033[0m");
            exit(1);
        }
    }

    int num = atoi(num_buff);
    if (num == 0 && num_buff[0] != '0'){
        fprintf(stderr, "\033[0;31m");
        printf("Not a number\n");
        fprintf(stderr, "\033[0m");
        exit(1);
    }
    return num;
}

char * _getString(){
    char c;
    char * buff = malloc(1);
    int index = 0;
    while ((c = getchar()) != EOF && c != '\n'){
        buff = realloc(buff, index + 1);
        if (buff == NULL){
            fprintf(stderr, "\033[0;31m");
            printf("Out of memory\n");
            fprintf(stderr, "\033[0m");
            exit(1);
        }
        buff[index++] = c;
    }
    buff = realloc(buff, index + 1);
    buff[index] = 0x00;
    return buff;
}

double _getDouble(){
    char c;
    char num_buff[20] = {0};
    int index = 0, has_point = 0;
    while ((c = getchar()) != EOF && c != '\n'){
        if (c == '.' && !has_point){
            if (index == 0){
                num_buff[index++] = '0';
            }
            num_buff[index++] = c;
        } else if (c == '-' && index == 0){
            num_buff[index++] = c;
        } else if (c >= '0' && c <= '9'){
            if (index < 20){
                num_buff[index++] = c;
            } else {
                fprintf(stderr, "\033[0;31m");
                printf("Number out of range\n");
                fprintf(stderr, "\033[0m");
                exit(1);
            }
        } else {
            fprintf(stderr, "\033[0;31m");
            printf("Not a number\n");
            fprintf(stderr, "\033[0m");
            exit(1);
        }
    }
    char * stop_val;
    double num = strtod(num_buff, &stop_val);
    if (errno == ERANGE){
        fprintf(stderr, "\033[0;31m");
        printf("Number out of range\n");
        fprintf(stderr, "\033[0m");
        exit(1);
    } else if (num == 0){
        fprintf(stderr, "\033[0;31m");
        printf("Invalid number\n");
        fprintf(stderr, "\033[0m");
        exit(1);
    }
    return num;
}
