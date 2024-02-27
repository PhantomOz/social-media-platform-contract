// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MyNFT} from "./NFT.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


//errors
error UserAlreadyExists();
error Unauthorised();
error URI_TooShort();
error BAD_REQUEST();

/// @title A decentralized social media platform
/// @author Favour Aniogor
/// @notice This contract enable users create, share and react to post on this platform.
/// @dev This contract utilizes openzeppelin and gasless transactions
contract SocialMedia {
    using Strings for uint256;

    mapping(address => User) public addressToUser;
    mapping(uint256 => Message) public idToMessage;
    mapping(uint256 => mapping(uint256 => Comment)) private messageIdToComment;
    mapping(uint256 => mapping(address => bool)) private messageIdToLikes;
    mapping(address => mapping(address => bool)) private addressToFollowers;
    uint256 private messageCounter;
    MyNFT private nftCollection;

    event NewUser(address indexed _user, string _username, uint256 _time);
    event NewPost(address indexed _user, uint256 indexed _postId, uint256 indexed _tokenId, address _tokenAddress);
    event LikePost(address indexed _user, uint256 _postId);
    event UnlikePost(address indexed _user, uint256 _postId);
    event FollowUser(address indexed _from, address indexed _to);
    event UnfollowUser(address indexed _from, address indexed _to);
    event Tip(address indexed _from, address indexed _to, uint256 _amount);
    event DeletPost(address indexed _user, uint256 indexed _postId);
    event CommentOnPost(address indexed _user, uint256 indexed _postId, uint256 _commentId);
    event WithdrawTip(address indexed _user, uint256 _amount);
    
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
        nftCollection = new MyNFT("SOCIAL MEDIA COLLECTION", "SMC");
        messageCounter = 0;
    }


    function registerUser(string memory _username) external {
        if(addressToUser[msg.sender]._isExists){
            revert UserAlreadyExists();
        }
        addressToUser[msg.sender] = User(_username, 0, 0, 0, true, 0, block.timestamp);
        emit NewUser(msg.sender, _username, block.timestamp);
    }

    function postContent(string memory _description, string calldata _tokenUri) external {
        if(!addressToUser[msg.sender]._isExists){
            revert Unauthorised();
        }
        if(bytes(_tokenUri).length < 8){
            revert URI_TooShort();
        }
        nftCollection.mintNft(_tokenUri, msg.sender);
        idToMessage[messageCounter] = Message(messageCounter, _description,msg.sender, 0, 0, block.timestamp);
        emit NewPost(msg.sender, messageCounter, messageCounter, address(nftCollection));
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
            messageIdToLikes[_messageId][msg.sender] = true;
            idToMessage[_messageId]._likes += 1;
            emit LikePost(msg.sender, _messageId);
        }else{
            messageIdToLikes[_messageId][msg.sender] = false;
            idToMessage[_messageId]._likes -= 1;
            emit UnlikePost(msg.sender, _messageId);
        }
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
        emit CommentOnPost(msg.sender, _messageId, _count);
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
            emit UnfollowUser(msg.sender, _user);
        }else{
            addressToFollowers[_user][msg.sender] = true;
            addressToUser[_user]._followers += 1;
            addressToUser[msg.sender]._following += 1;
            emit FollowUser(msg.sender, _user);
        }
    }

    function tipCreator(address _creator) external payable  {
        if(!addressToUser[_creator]._isExists){
            revert BAD_REQUEST();
        }
        addressToUser[_creator]._wallet += msg.value;
        emit Tip(msg.sender, _creator, msg.value);
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
        emit DeletPost(msg.sender, _contentId);
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
        emit WithdrawTip(msg.sender, balance);
    }

    function shareContent(uint256 _contentId) external view returns(string memory _link){
        if(idToMessage[_contentId]._createdAt == 0){
            revert BAD_REQUEST();
        }
        _link = string.concat("https://testnets.opensea.io/assets/mumbai/", Strings.toHexString(uint256(uint160(address(nftCollection))), 20), "/", _contentId.toString());
    }
}