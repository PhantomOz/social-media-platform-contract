// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//errors
error UserAlreadyExists();
error Unauthorised();
error URI_TooShort();

/// @title A decentralized social media platform
/// @author Favour Aniogor
/// @notice This contract enable users create, share and react to post on this platform.
/// @dev This contract utilizes openzeppelin and gasless transactions
contract SocialMedia {
    mapping(address => User) private addressToUser;
    mapping(uint256 => Message) private idToMessage;
    mapping(uint256 => mapping(uint256 => Comment)) private messageIdToComment;
    mapping(uint256 => mapping(address => bool)) private messageIdToLikes;
    mapping(address => mapping(address => bool)) private addressToFollowers;
    uint256 private messageCounter;

    struct User {
        string _username;
        uint256 _followers;
        uint256 _following;
        uint256 _wallet;
        bool _isExists;
        uint256 _postCount;
        uint256 _createdAt;
    }

    struct Message {
        uint256 _tokenId;
        string _description;
        address _author;
        uint256 _likes;
        uint256 _createdAt;
    }
    struct Comment {
        string message;
    }

    function registerUser(string memory _username) external {
        if(addressToUser[msg.sender]._isExists){
            revert UserAlreadyExists();
        }
        addressToUser[msg.sender] = User(_username, 0, 0, 0, true, 0, block.timestamp);
        //emit an event
    }
    function postContent(string memory _description, string calldata _tokenUri) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(bytes(_tokenUri).length < 8){
            revert URI_TooShort();
        }
        //mint nft and change tokenId in the Message Struct
        idToMessage[messageCounter] = Message(messageCounter, _description,msg.sender, 0, block.timestamp);
        //emit event of post
    }
    function likeContent() external {}
    function commentOnContent() external {}
    function followUser() external {}
    function unFollowUser() external {}
    function shareContent() external {}
    function tipCreator() external {}
    function deleteContent() external {}
    function withdrawTip() external {}
}