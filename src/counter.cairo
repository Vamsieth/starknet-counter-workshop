// counter contract
#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T);
}

#[starknet::contract]
pub mod Counter {
    
    Use super::{ICounter, ICounterDispatcher,ICounterDispatcherTrait};
    
    #[storage]
    struct Storage {
        counter: u32
    }

    // this event will emit whenever the state variable counter increases
    #[derive(Drop,starknet::Event)]
    struct CounterIncreased {
       #[key]
       value: u32
    }

    // event enum 
    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased
    }

    #[constructor]
    fn constructor(ref self: ContractState, _counter: u32) {
        self.counter.write(_counter);
    }

    #[abi(embed_v0)]
    impl ICounterImpl of ICounter<ContractState>{
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            Self.counter.write(self.counter.read()+1);
            self.emit(CounterIncreased{value: self.counter.read()});
        }
    }
}