#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT REST
do
  if [[ $WINNER != winner ]]
  then
  # If team present
  IS_TEAM_ADDED=$($PSQL "SELECT name from teams WHERE name = '$WINNER'")
    if [[ -z $IS_TEAM_ADDED ]]
    then
      echo "$($PSQL "INSERT INTO teams(name) values('$WINNER')")"
    fi
  IS_TEAM_ADDED=$($PSQL "SELECT name from teams WHERE name = '$OPPONENT'")
    if [[ -z $IS_TEAM_ADDED ]]
    then
      $PSQL "INSERT INTO teams(name) values('$OPPONENT')"
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id from teams where name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
