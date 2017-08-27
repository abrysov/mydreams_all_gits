var data = [
    {
        "id": 9244,
        "full_name": "Ярослав ",
        "gender": "male",
        "vip": false,
        "celebrity": false,
        "city": "Витебск",
        "country": "Беларусь",
        "visits_count": 1424,
        "avatar": {
            "small": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/9244/small_file.jpeg",
            "pre_medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/9244/pre_medium_file.jpeg",
            "medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/9244/medium_file.jpeg",
            "large": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/9244/large_file.jpeg"
        }
    },
    {
        "id": 17610,
        "full_name": "Владимир Васин",
        "gender": "male",
        "vip": false,
        "celebrity": false,
        "city": "Нефтеюганск",
        "country": "Россия",
        "visits_count": 107,
        "avatar": {
            "small": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/17610/small_file.jpeg",
            "pre_medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/17610/pre_medium_file.jpeg",
            "medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/17610/medium_file.jpeg",
            "large": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/17610/large_file.jpeg"
        }
    },
    {
        "id": 5147,
        "full_name": "Татьяна Баранова",
        "gender": "female",
        "vip": false,
        "celebrity": false,
        "city": "Нижний Тагил",
        "country": "Россия",
        "visits_count": 378,
        "avatar": {
            "small": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/5147/small_file.jpeg",
            "pre_medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/5147/pre_medium_file.jpeg",
            "medium": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/5147/medium_file.jpeg",
            "large": "//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/5147/large_file.jpeg"
        }
    }
];

var UsersFeed = React.createClass({
    render: function(){
        return (
            <div>
                <UsersFeedUsers data={this.props.data} />
            </div>
        )
    },
    getInitialState: function () {
        return ({users: []});
    },
    componentDidMount: function () {

        this.serverRequest = $.ajax({
            url: this.props.source,
            dataType: 'jsonp',
            success: function(result) {
                console.log(response.dreamers);
                this.setState({users: response.dreamers});
            }.bind(this)
        });

    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    }

});

var UsersFeedUser = React.createClass({
    render: function(){
        return (
            <a className="head_feed__item" href={"/account/dreamers/" + this.props.id + "/dreams"}>
                <img src={this.props.avatar} />
            </a>
        )
    }
});

var UsersFeedUsers = React.createClass({
    render: function(){
        /*var people = this.props.data.map(function(person){
            return <UsersFeedUser id={person.id} avatar={person.avatar.pre_medium} />
        });*/
        var people = [];
        return (
            <div>
                {people}
            </div>
        )
    }
});

ReactDOM.render(<UsersFeed source="http://mydreams.club/api/web/dreamers/leaders?per=10" />, $('.head_feed')[0] );