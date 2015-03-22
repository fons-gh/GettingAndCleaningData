Dataset structure
-----------------
  
  
  ```r
  str(dtTidy)
  ```
  
  ```
  ## Classes 'data.table' and 'data.frame':	180 obs. of  3 variables:
  ##  $ subject     : int  1 1 1 1 1 1 2 2 2 2 ...
  ##  $ activityName: chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
  ##  $ average     : num  -0.682 -0.725 -0.752 -0.193 -0.149 ...
  ##  - attr(*, "sorted")= chr  "subject" "activityName"
  ##  - attr(*, ".internal.selfref")=<externalptr>
  ```

List the key variables in the data table
----------------------------------------
  
  
  ```r
  key(dtTidy)
  ```
  
  ```
  ## [1] "subject"      "activityName"
  ```

Show a few rows of the dataset
------------------------------
  
  
  ```r
  dtTidy
  ```
  
  ```
  ##      subject       activityName    average
  ##   1:       1             LAYING -0.6815820
  ##   2:       1            SITTING -0.7250103
  ##   3:       1           STANDING -0.7518869
  ##   4:       1            WALKING -0.1932046
  ##   5:       1 WALKING_DOWNSTAIRS -0.1493580
  ##  ---                                      
  ## 176:      30            SITTING -0.7320585
  ## 177:      30           STANDING -0.7142919
  ## 178:      30            WALKING -0.2670206
  ## 179:      30 WALKING_DOWNSTAIRS -0.2175234
  ## 180:      30   WALKING_UPSTAIRS -0.3389130
  ```

Summary of variables
--------------------
  
  
  ```r
  summary(dtTidy)
  ```
  
  ```
  ##     subject     activityName          average       
  ##  Min.   : 1.0   Length:180         Min.   :-0.7535  
  ##  1st Qu.: 8.0   Class :character   1st Qu.:-0.7337  
  ##  Median :15.5   Mode  :character   Median :-0.5452  
  ##  Mean   :15.5                      Mean   :-0.4844  
  ##  3rd Qu.:23.0                      3rd Qu.:-0.2410  
  ##  Max.   :30.0                      Max.   : 0.1549
  ```

List all possible combinations of features
------------------------------------------
  
  
  ```r
  dtTidy <- dt[, list(average = mean(value)), by=key(dt)]
  ```

Save to file
------------
  
  Save data table objects to a tab-delimited text file called `tidyDataset.txt`.


```r
write.table(dtTidy, file = "tidyDataSet.txt",  sep="\t", row.names=FALSE)
```
