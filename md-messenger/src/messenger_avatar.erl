-module(messenger_avatar).
-export([url/2]).

-define(SALT, "bni3u4bno3i4uh").
%% TODO: Move ASSET_HOST to config
-define(ASSET_HOST, "//dncw63ov7q9kh.cloudfront.net").
-define(STORE_DIR_PREFIX, "uploads/dreamer/avatar").

url(_, null) ->
    null;
url(Id, FileName) ->
    iolist_to_binary([?ASSET_HOST, "/", store_dir(Id, FileName)]).

store_dir(Id, FileName) ->
    filename:join([?STORE_DIR_PREFIX, folder_name(Id), FileName]).

folder_name(Id) ->
    Hash = encode(integer_to_list(Id)),
    Len = 8,
    %% Split hash into 4 equal parts by 8 digits
    %% 8b1a9953c4611296a827abf8c47804d7 --> 8b1a9953/c4611296/a827abf8/c47804d7
    Parts = lists:reverse(lists:foldl(fun(I, Acc) ->
        Start = Len * I + 1,
        Slice = lists:sublist(Hash, Start, Len),
        [Slice | Acc]
    end, [], lists:seq(0, 3))),
    filename:join(Parts).

encode(String) ->
    Digest = crypto:hash(md5, String ++ ?SALT),
    %% Format as hexdigest
    lists:flatten([io_lib:format("~2.16.0b", [X]) || X <- binary_to_list(Digest)]).
