// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//errors
error UserAlreadyExists();

/// @title A decentralized social media platform
/// @author Favour Aniogor
/// @notice This contract enable users create, share and react to post on this platform.
/// @dev This contract utilizes openzeppelin and gasless transactions
contract SocialMedia {
    mapping(address => User) private addressToUser;
    mapping(uint256 => Message) private idToMessage;
    mapping(uint256 => mapping(uint256 => Comment)) private messageIdToComment;

    struct User {
        string _username;
        uint256 _followers;
        uint256 _following;
        uint256 _wallet;
        bool _isExists;
        uint256 _postCount;
    }

    struct Message {
        uint256 _tokenId;
    }
    struct Comment {
        string message;
    }

    function registerUser(string memory _username) external {
        if(addressToUser[msg.sender]._isExists){
            revert UserAlreadyExists();
        }
        addressToUser[msg.sender] = User(_username, 0, 0, 0, true, 0);
        //emit an event
    }
    function postContent() external {}
    function likeContent() external {}
    function commentOnContent() external {}
    function followUser() external {}
    function unFollowUser() external {}
    function shareContent() external {}
    function tipCreator() external {}
    function deleteContent() external {}
    function withdrawTip() external {}
}