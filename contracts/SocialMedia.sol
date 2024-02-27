// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;


/// @title A decentralized social media platform
/// @author Favour Aniogor
/// @notice This contract enable users create, share and react to post on this platform.
/// @dev This contract utilizes openzeppelin and gasless transactions
contract SocialMedia {
    struct User {
        string username;
        uint256 followers;
        uint256 following;
        uint256 wallet;
        bool isExists;
    }

    struct Message {
        uint256 _tokenId;
    }
    struct Comment {
        string message;
    }

    function registerUser() external {}
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