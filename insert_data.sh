#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #skip first line
  if [[ $YEAR != year ]]
  #get team_id
  then TEAM_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    #if not found
    if [[ -z $TEAM_ID ]]
    #insert team
    then
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then echo "Inserted into teams, $WINNER"
      fi
    #get new team_id
    TEAM_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #skip first line
  if [[ $YEAR != year ]]
  #get team_id
  then TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    #if not found
    if [[ -z $TEAM_ID ]]
    #insert team
    then
    INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then echo "Inserted into teams, $OPPONENT"
      fi
    #get new team_id
    TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #skip first line
  if [[ $YEAR != year ]]
  #get game_id
  then
  WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
  GAME_ID=$($PSQL "select game_id from games where year = '$YEAR' and round = '$ROUND' and winner_id = '$WINNER_ID' and opponent_id = '$OPPONENT_ID'")
    if [[ -z $GAME_ID ]]
    #insert game
    then
    INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOALS, $OGOALS)")
      if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
      then 
      echo "Inserted into games, $YEAR : $ROUND"
      fi
    #get new game_id
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
    GAME_ID=$($PSQL "select game_id from games where year = '$YEAR' and round = '$ROUND' and winner_id = '$WINNER_ID' and opponent_id = '$OPPONENT_ID'")
    fi
  fi
done