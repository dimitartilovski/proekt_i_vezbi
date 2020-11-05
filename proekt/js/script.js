//Authentication
// var token = localStorage.getItem("token");
// if (!token) {
//   window.location.href = "pages/login.html";
// }

// var email = localStorage.getItem("email");
// if (!email) {
//   window.location.href = "pages/login.html";
// }

document.getElementById("post-email").innerText = email;

function logout() {
  localStorage.clear();
  window.location.href = "pages/login.html";
}

//Global variables
var url =
  "https://dimitar-d5838.firebaseio.com/extream/posts.json?auth=" + token;
var allPosts = [];

//----------------------------------------------------------------------------------------------------
//Part 2:
//On submiting the form you should take the values of the 3 inputs and make a post request to create
//new post on the server. The url for the request is in the URL variable above. The object that you should be
//sending in the body of the request needs to have this format:
var example = {
  username: "johndoe",
  image: "http://someimage.com/image.jpeg",
  description: "Short description of the image"
};
//if the post is succesfuly created make an alert saying "The post was created with id:FH76DS4".
//Instead of the FH76DS4 you should put the key that the server returns.

function createPost(event) {
  event.preventDefault();

  var form = event.target;

  var post = {
    username: email,
    image: form.image.value,
    description: form.description.value
  };

  fetch(url, {
    method: "POST",
    body: JSON.stringify(post)
  })
    .then(function(res) {
      return res.json();
    })
    .then(function(data) {
      //form.username.value = "";
      form.image.value = "";
      form.description.value = "";
      alert("The post was created with id: " + data.name);
    });
}

//----------------------------------------------------------------------------------------------------
// Part 3:
//make a ajax request to get all the posts. The url for the request is in the variable url.
//when you get the posts, you will need to remap it into an array of objects that are in the format
//like in the example:
var example = {
  id: "the key of the object",
  description: "This will stay description",
  username: "this will stay username",
  imgSrc: "This will be remapped from image to imgSrc"
};
//and put the remapped array into the variable allPosts. After that you will need to reverse the allPosts array.
//Be careful that the json the server returns is an object that have another objects inside. First you will need
//to make an array of the object's keys with Object.keys() and then use .map on that array.
// getPosts();
function getPosts() {
  fetch(url)
    .then(function(res) {
      if (res.status == 401) {
        logout();
      }
      return res.json();
    })
    .then(function(data) {
      if (data.error) {
        alert("You are not logged in!");
        return;
      }

      allPosts = Object.keys(data).map(function(key) {
        return {
          id: key,
          description: data[key].description,
          username: data[key].username,
          imgSrc: data[key].image
        };
      });

      onReverse();
    });
}

//----------------------------------------------------------------------------------------------------
//Part 4:
//Create a function drawPosts that will loop through an array sent as a parameter and for every post of
//the array it will make a div with class card. In that newly created div you will need to append 3 elements.
//First you will need to create an image element and fill the src attribute with the value from
//the post's imgSrc property. Then you will need to create a h2 element and put the value from
//the post's username property as text of the h2. And also create a paragraph element and as text for
//it put the post's description property. After that you will need to append the DIV with class card
//to the DIV with ID all-posts in the HTML.(do not forget to delete the html from the div with id all-posts
//at the start of the function to clear it from before)

function drawPosts(postsArray) {
  var allPostsDiv = document.getElementById("all-posts");
  allPostsDiv.innerHTML = "";

  postsArray.forEach(function(element) {
    var div = document.createElement("div");
    div.className = "card";

    var image = document.createElement("img");
    image.src = element.imgSrc;

    var h2 = document.createElement("h2");
    h2.innerText = element.username;

    var p = document.createElement("p");
    p.innerText = element.description;

    div.append(image, h2, p);
    allPostsDiv.append(div);

    //EXERCISE 1
    if (email == element.username) {
      div.addEventListener("click", function() {
        window.location.href = "pages/edit-post.html?id=" + element.id;
      });
    }
  });
}

//----------------------------------------------------------------------------------------------------
//Part 5:
//1.On click on the REFRESH button you will need to first execute the getPosts function execute the drawPosts function with allPosts array as a
//parameter.
function onRefresh() {
  getPosts();
}

//2.On click on the REVERSE button you will need to first reverse the allPosts array then execute
//the drawPosts function with the allPosts as a parameter.
function onReverse() {
  allPosts.reverse();
  drawPosts(allPosts);
}

//3.On click on SORT BY ASCENDING you will need to first sort the array by the post's username in ASCENDING order
//and then execute the drawPosts function.
function onSortAscending() {
  allPosts.sort(function(a, b) {
    var usernameA = a.username.toLowerCase();
    var usernameB = b.username.toLowerCase();

    if (usernameA < usernameB) {
      return -1;
    }

    if (usernameA > usernameB) {
      return 1;
    }

    return 0;
  });

  drawPosts(allPosts);
}

//4. On SORT BY DESCENDING you will need to first sort the array by the post's username in DESCENDING order
//and then execute the drawPosts function.
function onSortDescending() {
  allPosts.sort(function(a, b) {
    var usernameA = a.username.toLowerCase();
    var usernameB = b.username.toLowerCase();

    if (usernameB < usernameA) {
      return -1;
    }

    if (usernameB > usernameA) {
      return 1;
    }

    return 0;
  });

  drawPosts(allPosts);
}

//----------------------------------------------------------------------------------------------------
//Part 6:
//As you write in the search input found in the HTML, you will need to filter the allPosts array.
//You will need to filter the array by the post's username or description. Then you will need to execute
//the drawPosts array with the new filtered array as a parameter.
function searchPosts(event) {
  var searchInputValue = event.target.value.toLowerCase().trim();

  var filteredPosts = allPosts.filter(function(post) {
    var username = post.username.toLowerCase().trim();
    var description = post.description.toLowerCase().trim();

    return (
      username.indexOf(searchInputValue) >= 0 ||
      description.indexOf(searchInputValue) >= 0
    );
  });

  drawPosts(filteredPosts);
}

//---------------------------------------------------------------------------------------------------
//On click on the button SORT BY DESCRIPTION ASC you will need to sort all of the posts by description.
//The first time you click on the button it will need to sort it by ascending. On the second time it will
//need to sort it by descending and the other way around. So it will need to act as a toggle.
// - First click you need to order by ascending and change the text of the button from SORT BY DESCRIPTION ASC
//   to SORT BY DESCRIPTION DESC
// - Second click needs to order by descending and change the text back to SORT BY DESCRIPTION ASC
// - And so on
var isAsc = true;
function sortByDescription(button) {
  allPosts.sort(function(a, b) {
    var descriptionA = a.description.toLowerCase();
    var descriptionB = b.description.toLowerCase();

    if (descriptionB < descriptionA) {
      return isAsc ? 1 : -1;
    }

    if (descriptionB > descriptionA) {
      return isAsc ? -1 : 1;
    }

    return 0;
  });
  button.innerText = isAsc
    ? "SORT BY DESCRIPTION ASC"
    : "SORT BY DESCRIPTION DESC";
  isAsc = !isAsc;

  drawPosts(allPosts);
}

//----------------------------------------------------------------------------------------------------
//You will need to change the onRefresh, so on click of it it will show only the first 4 posts not all posts.
//For that you can use the array slicing method we have learnt. On every click on SHOW MORE... button you will need
// to show 4 more posts. For example you always start with 4 posts, when you click show more you now show 8 posts,
//on clicking show more again you will see 12 and so on.
//BONUS: if there is no more posts to show change the style of the button to display:none. And on refresh return it to
//block.
var showing = 4; //use this variable to know how much you are showing.Increse this variable every time show more is clicked.

function showMore() {}


//On click on the button SHOW MY POSTS you will need to filter all the posts and return
//only the posts done by the logged user.
function showMyPosts() {}
