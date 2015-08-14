module dunit.vector;

class Vector(T) {
private:
    T[] array = null;
    int realSize = 0;
public:
    this(int n) {
        if (n <= 0) {
            throw new Exception("Size of vector must be positive.");
        }
        array = new T[2*n];
    }
    ~this() {
        destroy(array);
        array = null;
    }
    int size() {
        return realSize;
    }
    void add(T val) {
        if (realSize++ == array.length) {
            array.length *= 2;
        }
        array[realSize-1] = val;
    }
}
