// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Subscription.sol";
import "../src/DAO.sol";
// import "../src/Content.sol";
import "../src/Authorization.sol";
import "../src/Analytics.sol";
import "../src/Token.sol";

contract Test {
    Subscription public subscriptionContract;
    DAO public daoContract;
    Content public contentContract;
    Authorization public authorizationContract;
    Analytics public analyticsContract;
    Token public tokenContract;

    address public owner;
    address public user1;
    address public user2;

    function setUp() public {
        owner = address(this);
        user1 = address(1);
        user2 = address(2);

        tokenContract = new Token("Token", "TKN", 1000000, 10);
        subscriptionContract = new Subscription(address(tokenContract));
        contentContract = new Content(address(subscriptionContract));
        daoContract = new DAO(address(contentContract), address(tokenContract));
        authorizationContract = new Authorization();
        analyticsContract = new Analytics();
    }

    function testSubscription() public {
        // Test subscribe function
        tokenContract.mint(user1, 20);
        subscriptionContract.subscribe(1);
        assertTrue(subscriptionContract.isSubscribed(user1));

        // Test extendSubscription function
        subscriptionContract.extendSubscription(1);
        assertEq(subscriptionContract.subscriptionExpiry(user1), block.timestamp + 2);

        // Test renewSubscription function
        subscriptionContract.renewSubscription(1);
        assertEq(subscriptionContract.subscriptionExpiry(user1), block.timestamp + 1);
    }

    function testDAO() public {
        // Test submitProposal function
        daoContract.submitProposal("Test proposal", DAO.ProposalType.ContentModeration);
        assertEq(daoContract.proposalCount(), 1);

        // Test vote function
        daoContract.vote(1, true);
        assertEq(daoContract.proposals(1).votes, 1);

        // Test executeProposal function
        daoContract.executeProposal(1, DAO.ProposalType.ContentModeration);
        assertTrue(daoContract.proposals(1).executed);
    }

    function testContent() public {
        // Test createContent function
        contentContract.createContent("Test content", "ipfs://test");
        assertEq(contentContract.contentCount(), 1);

        // Test monetizeContent function
        contentContract.monetizeContent(1);
        assertTrue(contentContract.contents(1).isMonetized);

        // Test viewContent function
        contentContract.viewContent(1);
        assertEq(contentContract.contents(1).views, 1);
    }

    function testAuthorization() public {
        // Test registerUser function
        authorizationContract.registerUser("TestUser", "(link unavailable)");
        assertTrue(authorizationContract.registeredUsers(user1));

        // Test getUserDetails function
        (string memory username, address userAddress, string memory profileImage) = authorizationContract.getUserDetails(user1);
        assertEq(username, "TestUser");
        assertEq(userAddress, user1);
        assertEq(profileImage, "(link unavailable)");
    }

    function testAnalytics() public {
        // Test trackView function
        analyticsContract.trackView(1);
        assertEq(analyticsContract.views(1), 1);

        // Test trackLike function
        analyticsContract.trackLike(1);
        assertEq(analyticsContract.likes(1), 1);

        // Test trackRating function
        analyticsContract.trackRating(1, 5);
        assertEq(analyticsContract.ratings(1), 5);
    }

    function testToken() public {
        // Test subscribe function
        tokenContract.subscribe();
        assertEq(tokenContract.balanceOf(user1), 0);

        // Test mint function
        tokenContract.mint(user1, 10);
        assertEq(tokenContract.balanceOf(user1), 10);
    }
}


