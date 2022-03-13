// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// A contract to pay workers
contract paySalary{
    //a struct for worker's details
    struct Workers{
        uint256 workerId;
        address payable workerAddress;
        uint256 workerSalary;
    }

    //initialize worker's Id at zero
    uint256 workerId = 0;

    //an array of type Workers
    Workers[] workers;

    // the address of the employer is payable to recieve the balance from the contract
    address payable employer;
    // mapping address to bool to confirm payment
    mapping (address => bool) paid;

    // set the one who deploys this contract as employer
    constructor () payable {
        employer = payable (msg.sender);
    }

    // require that the deployer of the contract is the employer
    modifier onlyEmployer {
        require (msg.sender == employer, "only employer can add workers or pay salaries");
        _;
    }

    // function to register worakers and the amount of their salaries which can only be done by the employer
    function registerWorker (address payable _workerAddress, uint256 _workerSalary) public onlyEmployer {
        workers.push(Workers(workerId++, _workerAddress, _workerSalary));
    }

    // function to pay workers which can only be called by the employer
    function payWorkers () public payable onlyEmployer {
        for (uint256 i = 0; i < workerId; i++)
        workers[i].workerAddress.transfer(workers[i].workerSalary);
        // the balance in the contract is then sent back to the employer
        uint256 amount = address(this).balance; 
        employer.transfer(amount);      
    }

    // function to display all workers
    function displayWorkers () public view returns (Workers[] memory){
        return workers;
    }
}