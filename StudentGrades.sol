pragma solidity ^0.8.0;

contract StudentGrades{

    mapping(address => Student) students;

    struct Student {
        mapping(string => Subject) lists;
        string[] subjectNames;
    }

    struct Subject {
        string name;
        Grade[] grades;
    }

    struct Grade{
        string subCode;
        uint scores;
    }

    function doesSubjectExists(string memory name) internal view returns(bool){
        for (uint i=0; i < students[msg.sender].subjectNames.length; i++){
            if (keccak256(bytes(students[msg.sender].subjectNames[i])) == keccak256(bytes(name))){
                return true;
            }
        }
        return false;
    }

    function createSubjects(string memory name) public {
        require(bytes(name).length > 0, "Empty name cannot exist");
        require(!doesSubjectExists(name), "The name already exists");
        students[msg.sender].subjectNames.push(name);
    }

    function getSubjectNames() public view returns(string[] memory){
        return students[msg.sender].subjectNames;
    }

    function addScores(uint scores, string memory subjectName, string memory subCodes) public {
        require(doesSubjectExists(subjectName), "The name does not exists");
        students[msg.sender].lists[subjectName].grades.push(Grade(subCodes, scores));
    }

    function getSubjectsWithGrades(string memory listName) public view returns(uint[] memory){
        require(doesSubjectExists(listName), "The subject does not exist");
        uint gradesLength = students[msg.sender].lists[listName].grades.length;
        uint[] memory subjectGrades = new uint[](gradesLength);
        for (uint i=0; i < gradesLength; i++){
            subjectGrades[i] = students[msg.sender].lists[listName].grades[i].scores;
        }
        return subjectGrades;
    }

}
