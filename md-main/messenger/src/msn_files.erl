-module(msn_files).
-export([avatar/3
        ,attachment/2]).

-define(SALT, "bni3u4bno3i4uh").
-define(AVATAR_SIZE, "pre_medium").
%% TODO: Move ASSET_HOST to config
-define(ASSET_HOST, "//dncw63ov7q9kh.cloudfront.net").
-define(STORE_DIR_PREFIX, "uploads").
-define(AVATAR_PREFIX, "dreamer/avatar").
-define(ATTACHMENT_PREFIX, "attachment/file").
-define(DEFAULT_AVATAR_MALE, "assets/defaults/avatars/male_medium-bf20d1c5b755bfdfee12dd1a079df4f0b50af58cc1dd01d9ba4b7ec953739d00.png").
-define(DEFAULT_AVATAR_FEMALE, "assets/defaults/avatars/female_medium-6f0b3683597b315571cab9a8bd19543682517590afc7c9261ac17b1b298cb68c.png").

avatar(_, null, <<"female">>) ->
    url(?DEFAULT_AVATAR_FEMALE);
avatar(_, null, _Gender) ->
    url(?DEFAULT_AVATAR_MALE);
avatar(Id, FileName, _Gender) ->
    url(avatar_store_dir(Id, FileName)).

attachment(Id, FileName) ->
    url(attachment_store_dir(Id, FileName)).

url(Path) ->
    iolist_to_binary([?ASSET_HOST, "/", Path]).

avatar_store_dir(Id, FileName) ->
    filename:join([
        ?STORE_DIR_PREFIX,
        ?AVATAR_PREFIX,
        folder_name(Id),
        iolist_to_binary([?AVATAR_SIZE, "_", FileName])
    ]).

attachment_store_dir(Id, FileName) ->
    filename:join([
        ?STORE_DIR_PREFIX,
        ?ATTACHMENT_PREFIX,
        folder_name(Id),
        FileName
    ]).

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
