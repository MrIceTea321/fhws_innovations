//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "hardhat/console.sol";

contract FhwsInnovationsContract {
    
    struct Student {
        string kNumber;
        address studentAddress;
        bool voted;
    }
    struct Innovation {
        bytes32 uniqueInnovationHash;
        uint votingCount;
        Student creator;
        string title;
        string description;
    }

    address private owner;

    bool public innovationProcessFinished;

    //search with registred address for student
    mapping(address => Student) private students;

    //check if student is registred
    mapping(string => bool) private kNumberAlreadyRegistred;

    //get innovations of creator student address
    mapping(address => Innovation[]) private innovationsOfStudent;

    //all created innovations
    Innovation[] private innovations;
    string[] private kNumbers;
    address[] private addresses;
    Innovation[] private winner;

    constructor() {
        owner = msg.sender;
    }

    modifier onylWithRegistredStudentAddress {
        require(studentUsesInitialRegistredAddress(), "You need to select your registred Wallet or register yourself with your kNumber.");
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only owner can end the innovaton process!");
        _;
    }

    modifier innovationProcessNotFinished{
        require(!innovationProcessFinished, "The innovation process is finished.");
        _;
    }

    modifier innovationProcessIsFinished {
        require(innovationProcessFinished, "The innovation process is not finished yet.");
        _;
    }

    function endInnovationProcess() public onlyOwner returns(Innovation[] memory)  {
        innovationProcessFinished = true;
        uint winningVoteCount = 0;
        for(uint i=0; i<innovations.length; i++){
            if(innovations[i].votingCount > winningVoteCount) {
                winningVoteCount = innovations[i].votingCount;
            }
        }
         for(uint i=0; i<innovations.length; i++){
            if(innovations[i].votingCount == winningVoteCount) {
                winner.push(innovations[i]);
            }
        }
        return winner;
    }

    function getWinnerOfInnovationProcess() public onlyOwner innovationProcessIsFinished view returns(Innovation[] memory) {
        return winner;
    }

    function restartInnovationProcess() public onlyOwner {
        innovationProcessFinished = false;
        for(uint i = 0; i<kNumbers.length; i++) {
            delete kNumberAlreadyRegistred[kNumbers[i]];
        }
        for(uint i = 0; i<addresses.length; i++) {
            delete students[addresses[i]];
            delete innovationsOfStudent[addresses[i]];
        }
        delete innovations;
        delete kNumbers;
        delete addresses;
        delete winner;
    }

    //registration process
    function initialRegistrationOfStudent(string memory _kNumber) public {
        if(!studentAlreadyRegistred(_kNumber)){
            Student memory newStudent = Student ({kNumber: _kNumber, studentAddress: msg.sender, voted: false});
            students[msg.sender] = newStudent;
            kNumberAlreadyRegistred[_kNumber] = true;
            kNumbers.push(_kNumber);
            addresses.push(msg.sender);
            console.log("Student created");
        } else console.log("Student already exists");
    }

    //check if student is already registred
    function studentAlreadyRegistred(string memory _kNumber) public view returns(bool){
        return kNumberAlreadyRegistred[_kNumber];
    }

    //check if student uses initial registred address
    function studentUsesInitialRegistredAddress() public view returns(bool){
        return students[msg.sender].studentAddress == msg.sender;
    }

    //get kNumber with student address
    function getKNumberOfStudentAddress() public onylWithRegistredStudentAddress view returns(string memory) {
        return students[msg.sender].kNumber;
    }

    //return student object
    function getStudent() public onylWithRegistredStudentAddress view returns(Student memory) {
        return students[msg.sender];
    }

    //return innovations of student 
    function getInnovationsOfStudent() public onylWithRegistredStudentAddress view returns(Innovation[] memory){
         return innovationsOfStudent[msg.sender];
    }

    //test onylWithRegistredStudentAddress
     function getAllInnovations() public onylWithRegistredStudentAddress view returns(Innovation[] memory){
        return innovations;
    }

    //Nur zum Testen onylWithRegistredStudentAddress
    function getFirstInnovation() public onylWithRegistredStudentAddress view returns(bytes32){
        return innovations[0].uniqueInnovationHash;
    }


     function genereateUniqueHashForInnovation(string memory _title, string memory _description) private onylWithRegistredStudentAddress view returns(bytes32) {
        return keccak256(abi.encodePacked(block.timestamp, getKNumberOfStudentAddress(), _title, _description));
    }

    function createInnovation(string memory _title, string memory _description) public onylWithRegistredStudentAddress { 
        bytes32 _uniqueInnovationHash = genereateUniqueHashForInnovation(_title, _description);
        Innovation memory newInnovation = Innovation ({uniqueInnovationHash: _uniqueInnovationHash, votingCount: 0,  creator: getStudent(), title: _title, description: _description});
        innovations.push(newInnovation);
        innovationsOfStudent[msg.sender].push(newInnovation);
        console.log("Innovation created");
    }

    function deleteInnovation(bytes32 _uniqueInnovationHash) public onylWithRegistredStudentAddress {
        for(uint i = 0; i < innovations.length; i++) {
            if(innovations[i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovations[i]=innovations[innovations.length-1];
                innovations.pop();
            }
        }

        for(uint i = 0; i<innovationsOfStudent[msg.sender].length; i++){
            if(innovationsOfStudent[msg.sender][i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovationsOfStudent[msg.sender][i]=innovationsOfStudent[msg.sender][innovationsOfStudent[msg.sender].length-1];
                innovationsOfStudent[msg.sender].pop();
            }
        }
        console.log("Innovation deleted");
    }

    function editInnovation(bytes32 _uniqueInnovationHash, string memory _title, string memory _description) public onylWithRegistredStudentAddress{
        deleteInnovation(_uniqueInnovationHash);
        createInnovation(_title, _description);
    }


    function vote(bytes32 _uniqueInnovationHash) public onylWithRegistredStudentAddress{
        for(uint i = 0; i < innovations.length; i++) {
            if(innovations[i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovations[i].votingCount++;
            }
        }

         for(uint i = 0; i<innovationsOfStudent[msg.sender].length; i++){
            if(innovationsOfStudent[msg.sender][i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovationsOfStudent[msg.sender][i].votingCount++;
            }
        }
        students[msg.sender].voted = true;
    }

    function unvote(bytes32 _uniqueInnovationHash) public onylWithRegistredStudentAddress{
        for(uint i = 0; i < innovations.length; i++) {
            if(innovations[i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovations[i].votingCount--;
            }
        }
        for(uint i = 0; i<innovationsOfStudent[msg.sender].length; i++){
            if(innovationsOfStudent[msg.sender][i].uniqueInnovationHash ==_uniqueInnovationHash){
                innovationsOfStudent[msg.sender][i].votingCount--;
            }
        }
        students[msg.sender].voted = false;
    }
}
