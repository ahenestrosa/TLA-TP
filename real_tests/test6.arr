start
    print "This program evaluates the cross and escalar product of two vectors\n";
    double[] arr1 = [0.0,0,0];
    double[] arr2 = [0.0,0,0];
    double[] arr3 = [0.0,0];
    double[] arr4 = [0.0,0];
    double[] arrOp1;
    double[] arrOp2;
    double[] resArrDoub;
    double resDoub;
    int size;

    print "First Choose the size of the vectors (2 o 3):\n";
    print "Size: ";
    size = getInt();

    if(size == 2){
        arrOp1 = arr3;
        arrOp2 = arr4;
    }
    else if( size == 3){
        arrOp1 = arr1;
        arrOp2 = arr2;
    }
    else{
        print "ERROR SIZE MUST BE 2 o 3\n";
        exit();
    }

    print "Choose the values for the first arrays\n";
    int i =0;
    while(i < size){
        print "Value for element ";
        print i;
        print ": ";
        arrOp1[i] = getDouble();
        i=i+1;
    }

    print "Choose the values for the second arrays\n";
    i =0;
    while(i < size){
        print "Value for element ";
        print i;
        print ": ";
        arrOp2[i] = getDouble();
        i = i +1;
    }

    print "\nCROSS PRODUCT: ";
    resArrDoub = arrOp1 *x arrOp2;
    print resArrDoub;

    print "SCALAR PRODUCT: ";
    resDoub = arrOp1 *. arrOp2;
    print resDoub;
    print "\n";
end
