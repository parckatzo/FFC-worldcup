#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams CASCADE")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $YEAR != year ]]
  then
    #Insert teams
    W_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

    if [[ -z $W_TEAMS ]]
      then
      INSERT_WTEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_WTEAM == "INSERT 0 1" ]]
        then
        echo Inserted into teams, $WINNER
      fi
    fi

    L_TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $L_TEAMS ]]
        then
        INSERT_LTEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
        if [[ $INSERT_LTEAM == "INSERT 0 1" ]]
          then
          echo Inserted into teams, $OPPONENT
        fi
    fi
  fi
    #Insert games

    W_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    L_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -n $W_TEAM_ID || -n $L_TEAM_ID ]]
      then
      if [[ $YEAR != year ]]
        then
        INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND','$W_TEAM_ID', '$L_TEAM_ID','$WINNER_GOALS','$OPPONENT_GOALS')")
        if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
          then 
          echo Inserted into games, $YEAR $ROUND
        fi
      fi
    fi
done
