library(RCurl)
library(stringr)
library(plotly)

##
##  FUNCTIONS
##

getMatchID <- function(data) {
  start = str_locate_all(pattern = "guild_war_current_match", data)[[1]][1,2]
  
  stats = substring(data, start)
  
  id_startpoint = str_locate_all(pattern = "id", stats)[[1]][1,2] + 3
  id_endpoint = str_locate_all(pattern = "enemy_guild_rank", stats)[[1]][1,1] - 3
  rank_startpoint = str_locate_all(pattern = "enemy_guild_rank", stats)[[1]][1,2] + 4
  rank_endpoint = str_locate_all(pattern = "result", stats)[[1]][1,1] - 4
  rival_startpoint = str_locate_all(pattern = "them_name", stats)[[1]][1,2] + 4
  rival_endpoint = str_locate_all(pattern = "them_leaders", stats)[[1]][1,1] - 4
  
  
  id = substring(stats, id_startpoint, id_endpoint)
  rank = substring(stats, rank_startpoint, rank_endpoint)
  rival = substring(stats, rival_startpoint, rival_endpoint)
  return(c(id, rank, rival))
}

update_rumble_stats <- function(url, g_url, rumble_scores) {
  data = getURL(url, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
  g_data = getURL(g_url, ssl.verifyhost=FALSE, ssl.verifypeer=FALSE)
  
  matchInfos = getMatchID(g_data)
  
  matchID = as.numeric(matchInfos[1])
  
  start = str_locate_all(pattern = '"data"', data)[[1]][1,2]
  end = str_locate_all(pattern = "win_count", data)[[1]][1,1]
  
  stats = substring(data, start, end)
  
  name_startpoint = str_locate_all(pattern = "name", stats)[[1]][,2] + 4
  name_endpoint = str_locate_all(pattern = "stat", stats)[[1]][,1] - 4
  stat_startpoint = str_locate_all(pattern = "stat", stats)[[1]][,2] + 4
  stat_endpoint = str_locate_all(pattern = "commander", stats)[[1]][,1] - 4
  
  nScores = matrix(ncol = 2, nrow = length(stat_endpoint))
  for (i in 1:length(stat_endpoint)) {
    nScores[i,1] = substring(stats, name_startpoint[i], name_endpoint[i])
    nScores[i,2] = substring(stats, stat_startpoint[i], stat_endpoint[i])
  }
  
  if (matchID == 0) {
    rownames(rumble_scores) = nScores[,1]
  }
  
  f = TRUE
  for (i in 1:length(name_startpoint)) {
    pos = which(nScores[,1] == rownames(rumble_scores)[i])
    if (length(pos) != 1) {
      if (f) {
        rumble_scores[i,matchID+1] = nScores[pos[1],2]
        f = FALSE
      } else {
        rumble_scores[i,matchID+1] = nScores[pos[2],2]
        f = TRUE
      }
    } else {
      rumble_scores[i,matchID+1] = nScores[pos,2]
    }
  }
  
  colnames(rumble_scores)[matchID+1] = matchInfos[3]
  
  return(rumble_scores)
}

own.mean <- function(data) {
  data = as.integer(data)
  return(mean(data))
}

own.sum <- function(data) {
  data = as.integer(data)
  return(sum(data))
}

clean.mean <- function(data) {
  data = as.integer(data)
  missed = which(data == 0)
  ret = sum(data) / (length(data) - length(missed))
  return(ret)
}

own.format <- function(data) {
  data = as.double(format(round(data, 2), nsmall = 2))
  return(data)
}


##
##  DATA
##

#fill in your id and hashed password, if your not sure which ones i mean, just ask :)
my_id = '5259558'
my_password = ''
#path is where you save the table with the scores, you need to change it
path = "/Users/bench/Desktop/rumble_scores.csv"

general_gw_stats = paste("https://cb-live.synapse-games.com/api.php?message=getGuildWarStatus&user_id=", my_id, "&password=", my_password, sep = "")
ennemy_gw_stats = paste("https://cb-live.synapse-games.com/api.php?message=getRankings&user_id=", my_id, "&password=", my_password, "&ranking_id=event_guild_war&ranking_index=1", sep = "")
own_gw_stats = paste("https://cb-live.synapse-games.com/api.php?message=getRankings&user_id=", my_id, "&password=", my_password, "&ranking_id=event_guild_war&ranking_index=0", sep = "")
guild_feed = paste("https://cb-live.synapse-games.com/api.php?message=getGuildFeed&user_id=", my_id, "&password=", my_password, sep = "")


##
##  CODE
##

##  Uncomment code below, when a new rumble sheets needs to get started for a new rumble.
#rumble_scores = matrix(ncol = 18, nrow = 50)
#colnames(rumble_scores) = rep("ennemy_guild", 18)
#rownames(rumble_scores) = new_rs[,1]
rumble_scores = read.csv(path, stringsAsFactors = FALSE)
names = rumble_scores[,1]
rumble_scores = as.matrix(rumble_scores[,-1])
rownames(rumble_scores) = names

rumble_scores = update_rumble_stats(own_gw_stats, general_gw_stats, rumble_scores)

write.csv(rumble_scores, path)
