import parsetoml, twitter, json, httpclient, os

proc errorHandling(s: string): void =
  echo s
  system.programResult = 1

when isMainModule:
  if os.paramCount() <= 1:
    errorHandling("2 args are required.")
  else:
    let filepath = $joinPath(
      getHomeDir(),
      ".config",
      "tw",
      $os.commandLineParams()[0] & ".toml"
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

      var resp = twitterAPI.statusesUpdate($os.commandLineParams()[1])
      if resp.status == $Http200:
        echo parseJson(resp.body)["text"]
      else:
        echo parseJson(resp.body).pretty
