start

    x = [1, 2, 3] * 3;
    y = 3 * [1, 2, 3];
    x = [1, 2, 3] / 3;
    y = [1, 2, 3] cross [1, 2, 3];
    z = z cross y;
    y = z cross [1, 2, 3];
    y = [1, 2, 3] cross y;

    y = [1, 2, 3] + y;
    y = [1, 2, 3] - y;
    y = [1, 2, 3] * y;
    y = [1, 2, 3] / y;
    y = [1, 2, 3] cross y;
    y = y + [1, 2, 3];
    y = y - [1, 2, 3];
    y = y * [1, 2, 3];
    y = y cross [1, 2, 3];
end