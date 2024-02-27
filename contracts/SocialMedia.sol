// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

error UserAlreadyExists();
error Unauthorised();
error URI_TooShort();
error BAD_REQUEST();

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
        uint256 createdAt;
    }

    struct Message {
        uint256 _tokenId;
        string _description;
        address _author;
        uint256 _likes;
        uint256 _commentCounts;
        uint256 _createdAt;
    }
    struct Comment {
        string _comment;
        uint256 _messagId;
        address _author;
        uint256 _createdAt;
    }

    constructor(){
        
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
        //mint nft
        idToMessage[messageCounter] = Message(messageCounter, _description,msg.sender, 0, 0, block.timestamp);
        //emit event of post
        messageCounter++;
    }
    function toggleLikeContent(uint256 _messageId) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(idToMessage[_messageId]._createdAt == 0){
            revert BAD_REQUEST();
        }
        if(!messageIdToLikes[_messageId][msg.sender]){
            idToMessage[_messageId]._likes += 1;
        }else{
            idToMessage[_messageId]._likes -= 1;
        }
        //emit like event
    }
    function commentOnContent(uint256 _messageId, string calldata _comment) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(idToMessage[_messageId]._createdAt == 0){
            revert BAD_REQUEST();
        }
        uint256 _count = idToMessage[_messageId]._commentCounts;
        messageIdToComment[_messageId][_count] = Comment(_comment, _messageId, msg.sender, block.timestamp);
        idToMessage[_messageId]._commentCounts += 1;
        //emit event here
    }
    function toggleFollowUser(address _user) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(!addressToUser[_user]._isExists){
            revert BAD_REQUEST();
        }
        if(addressToFollowers[_user][msg.sender]){
            addressToFollowers[_user][msg.sender] = false;
            addressToUser[_user]._followers -= 1;
            addressToUser[msg.sender]._following -= 1;
            //emit unfollow event
        }else{
            addressToFollowers[_user][msg.sender] = true;
            addressToUser[_user]._followers += 1;
            addressToUser[msg.sender]._following += 1;
            //emit follow event
        }
    }
    function tipCreator(address _creator) external payable  {
        if(!addressToUser[_creator]._isExists){
            revert BAD_REQUEST();
        }
        addressToUser[_creator]._wallet += msg.value;
        //emit tip given 
    }
    function deleteContent(uint256 _contentId) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(idToMessage[_contentId]._createdAt == 0){
            revert BAD_REQUEST();
        }
        if(idToMessage[_contentId]._author != msg.sender){
            revert BAD_REQUEST();
        }
        delete(idToMessage[_contentId]);
        //see if the token
    }
    function withdrawTip() external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(addressToUser[msg.sender]._wallet <= 0){
            revert BAD_REQUEST();
        }
        uint256 balance = addressToUser[msg.sender]._wallet;
        addressToUser[msg.sender]._wallet = 0;
        (bool s,) = payable (msg.sender).call{value: balance}("");
        require(s);
        //emit withdrawal event
    }
    function shareContent() external {}
}