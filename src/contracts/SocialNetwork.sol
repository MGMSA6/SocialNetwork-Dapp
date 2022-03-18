pragma solidity ^0.5.0;

contract SocialNetwork {
    string public name;
    uint256 public postCount;
    mapping(uint256 => Post) public posts;

    struct Post {
        uint256 id;
        string content;
        uint256 tipAmount;
        address payable author;
    }

    event PostCreated(
        uint256 id,
        string content,
        uint256 tipAmount,
        address payable author
    );

    event PostTipped(
        uint256 id,
        string content,
        uint256 tipAmount,
        address payable author
    );

    constructor() public {
        name = "Dapp University Social Network";
    }

    function createPost(string memory _content) public {
        // Require valid content
        require(bytes(_content).length > 0);

        // Increment the postCount
        postCount++;

        // Create the post
        posts[postCount] = Post(postCount, _content, 0, msg.sender);

        // Trigger event
        emit PostCreated(postCount, _content, 0, msg.sender);
    }

    function tipPost(uint256 _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= postCount);

        // Fetch the post
        Post memory _post = posts[postCount];

        // Fetch author
        address payable _author = _post.author;

        // Pay the author
        address(_author).transfer(msg.value);

        // Increment the tip amount
        _post.tipAmount = _post.tipAmount + msg.value;

        // Update the post
        posts[postCount] = _post;

        // Tigger event
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
    }
}
