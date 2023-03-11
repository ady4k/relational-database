#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YR ROUND WIN OPP WIN_G OPP_G
do
  if [[ $YR != "year" ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    if [[ -z $WIN_ID ]]
    then
      INSERT_RES=$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")
    fi
    
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_RES=$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")
    fi

    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'")
    INSERT_RES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YR, '$ROUND', $WIN_ID, $OPP_ID, $WIN_G, $OPP_G)")
  fi
done