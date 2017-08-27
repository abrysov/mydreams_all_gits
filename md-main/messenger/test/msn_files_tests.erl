-module(msn_files_tests).
-include_lib("eunit/include/eunit.hrl").

-define(TESTEE_MOD, msn_files).

avatar_test() ->
    ?assertEqual(
        <<"//dncw63ov7q9kh.cloudfront.net/assets/defaults/avatars/male_medium-bf20d1c5b755bfdfee12dd1a079df4f0b50af58cc1dd01d9ba4b7ec953739d00.png">>,
        ?TESTEE_MOD:avatar(11, null, <<"male">>)
    ),
    ?assertEqual(
        <<"//dncw63ov7q9kh.cloudfront.net/assets/defaults/avatars/female_medium-6f0b3683597b315571cab9a8bd19543682517590afc7c9261ac17b1b298cb68c.png">>,
        ?TESTEE_MOD:avatar(11, null, <<"female">>)
    ),
    ?assertEqual(
        <<"//dncw63ov7q9kh.cloudfront.net/uploads/dreamer/avatar/3982cd03/5f8ea981/c6237c49/f7017496/pre_medium_faceplam.png">>,
        ?TESTEE_MOD:avatar(11, <<"faceplam.png">>, <<"male">>)
    ).

attachment_test() ->
    ?assertEqual(
        <<"//dncw63ov7q9kh.cloudfront.net/uploads/attachment/file/3982cd03/5f8ea981/c6237c49/f7017496/kittens.jpg">>,
        ?TESTEE_MOD:attachment(11, <<"kittens.jpg">>)
    ).

folder_name_test() ->
    ?assertEqual("8a3e518c/cc62a84e/5a3919de/ed8a9a39", ?TESTEE_MOD:folder_name(1)),
    ?assertEqual("2a4ef269/7f0e25ee/34731501/35f128c7", ?TESTEE_MOD:folder_name(2)),
    ?assertEqual("cba35992/ae896df1/90a4d7c1/9b6c56ac", ?TESTEE_MOD:folder_name(3)),
    ?assertEqual("622b5dbf/c30a7dd9/2362d985/0946aa88", ?TESTEE_MOD:folder_name(4)),
    ?assertEqual("95a8291e/826bb6e2/30abbc5d/9a24e072", ?TESTEE_MOD:folder_name(5)).
