// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface IEscuela {
    struct User {
        string name;
        Rol rol;
    }

    enum Rol {
        teacher,
        students
    }

    event newStudent(address user);

    function addUser(address user, string memory name, Rol rol) external returns (bool);
    function changeUserName(address user, string memory newName) external returns (bool);
}

abstract contract RatingsTeachers {
    mapping(address => uint256) _ratingsTeachers;

    function addToTeacher(address teacher) public returns (bool) {
        _ratingsTeachers[teacher]++;
        return true;
    }

    function ratingTeacher(address teacher) public virtual view returns (uint256);
}

abstract contract RatingsStudents {
    mapping(address => uint256) _ratingsStudents;

    function addToStudent(address student) public returns (bool) {
        _ratingsStudents[student]++;
        return true;
    }

    function ratingStudent(address student) public virtual view returns (uint256);
}

contract Academy is IEscuela, RatingsTeachers, RatingsStudents {
    uint256 public countStudents;
    mapping(address => User) public users;

    function addUser(address user, string memory name, Rol rol) public override returns (bool) {
        users[user] = User(name, rol);
        if(rol == IEscuela.Rol.student) {
            addCount();
            emit newStudent(user);
        }
        return true;
    }

    function changeUserName(address user, string memory newName) public override returns (bool) {
        users[user].name = newName;
        return true;
    }

    function ratingTeacher(address teacher) public override view returns (uint256) {
        return _ratingsTeachers[teacher];
    }

    function ratingStudent(address student) public override view returns (uint256) {
        return _ratingsStudents[student];
    }

    function addRatTeacher(address teacher) public returns (bool) {
        super.addToTeacher(teacher);
        return true;
    }

    function addRatStudent(address student) public returns (bool) {
        RatingsStudents.addToStudent(student);
        return true;
    }

    function addCount() private returns(bool) {
        countStudents++;
        return true;
    }
}