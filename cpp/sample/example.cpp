#include <iostream>
#include <string>
#include <memory>
#include <vector>
using namespace std;

class Car {

    public:
        int type = 1;
        string name = "abc";

        Car(int type, string name){
            this->type = type;
            this->name = name;
        }

        Car(){
        }

};


int sum(int a, int b){
    return a + b;
}


int main(){

    auto p = 100;
    auto myCar = make_unique<Car>();
    myCar->type = 2;

    auto* ptr = new Car(2,"Pointer_Car");
    cout << ptr << "\n";
    

    cout << "Hello World" << "\n";
    cout << sum(p,10) << "\n";
    cout << myCar->type << "\n";

    vector<int> my_list;

    for(int i = 0; i < 10; ++i){
        my_list.push_back(i);
    }

    for(auto i : my_list){
        cout << i << "\n";
    }
}

