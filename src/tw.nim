import parsetoml, twitter, json, httpclient, os, cligen

proc errorHandling(s: string): void =
  echo s
  system.programResult = 1

proc tweet(username: string, text: string): void =
  let filepath = $joinPath(
    getHomeDir(),
    ".config",
    "tw",
    username & ".toml"
  )

  if not os.fileExists(filepath):
    errorHandling("File is not exists.")
  else:
    let config = parsetoml.parseFile(filepath)
    let consumerToken = newConsumerToken(
                          config["Twitter"]["ConsumerKey"].getStr(),
                          config["Twitter"]["ConsumerSecret"].getStr()
                        )
    let twitterAPI = newTwitterAPI(
                      consumerToken,
                      config["Twitter"]["AccessToken"].getStr(),
                      config["Twitter"]["AccessTokenSecret"].getStr()
                    )

    var resp = twitterAPI.statusesUpdate(text)
    if resp.status == $Http200:
      let tweet = parseJson(resp.body)
      let tweetUrl = [
        "https://twitter.com",
        tweet["user"]["screen_name"].getStr(),
        "status",
        $tweet["id"]
      ].join("/")
      echo tweetUrl
    else:
      echo parseJson(resp.body).pretty

when isMainModule:
  dispatch(tweet)
