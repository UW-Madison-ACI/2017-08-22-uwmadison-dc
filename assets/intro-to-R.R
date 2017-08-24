#Math operations in R
15 + 5
15 - 5
15 * 5
15/5 #Show space is unnecessary.

#Functions
log(5)
log(5, 6)
log() #Show data to log is needed.
log(x = 5) #Show that x is the name of the first argument.
log(x = 5, base = 3) #We can name which input goes with which argument.
log(5, 3) #Without doing so, order of inputs matters.
log(3, 5)
log(base = 3, x = 5) #But, with names, order no longer matters.
?log #Show help page for function

#Script files
15 - 5
#Hit enter to demonstrate hitting enter won't run code from script like it does in console.
15 - 5
15 + 5 #Demonstrate the power of comments!

#Objects
math <- 15 + 5 #Makes an object called math that holds "20"
math #Show that R knows what math means.
math / 7.43 #Can now use math in place of the number 20 in math problems.
new_math <- math / 7.43 #Make new object with the value in an old object.
sqrt(new_math) #Square root function
round(new_math) #Rounding function
round(new_math, digits = 2) #Showcase second argument, digits, which changes how round() rounds

blah = 4 #Show that = sign works too for assignment.
#Hot key for arrow is alt + -

#Object names
meh1 <- 6 #Can contain numbers
1meh <- 6 #Can't start with one though.
t2 <- 8 #Can be short names.
sfieifsegjbwrjgbsrijgbsrjbgkjwbfkwjbfgkjsbfksjbs <- 0 #Or long names.
COLUMN_NAME #I use caps and underscores in my naming convention.
ColumnName #Others use Camelcase

mean, t, c, data #All function names! Don't pick them.
mean <- 8 #Technically allowed, but don't do it.
column.name <- 8 #Also allowed, but don't do it because functions often use . to separate words.
Age = 18 #Demonstrate case-sensitivity of R
age #Not found because Age and age are different!

#Challenge 1: 
x <- 50
y <- x * 2
x <- 75
y #Show that y is 100
y <- x * 2 #Show we have to run this again to change y.
y #Show that y is now 150 once we do that.

##Opening and working with the data.
surveys <- read.csv(file = "http://kbroman.org/datacarp/portal_data_joined.csv")

#Probably should download the file first just so we have a local copy on our computer.
download.file(url = "http://kbroman.org/datacarp/portal_data_joined.csv", destfile = "raw_data/portal_data_joined.csv")
surveys <- read.csv("raw_data/portal_data_joined.csv")

head(surveys)#Showcasing functions for exploring data frames.
tail(surveys)
dim(surveys)
nrow(surveys)
ncol(surveys)
names(surveys)
rownames(surveys)

#Really powerful exploration tools!
str(surveys)
summary(surveys)

str(math) #Shows that str is generic and can be used on many types of objects.

##Indexing--extracting values out of an object that we've made.
surveys[1,5] #Value in row 1, column 5.
surveys[5,1] #Value in row 5, column 1.
surveys[2,] #We can get the whole second row...
surveys[,7] #Or the whole seventh column by leaving the other spot blank.

surveys[,"sex"] #Two additional options here for getting entire columns from a data frame.
surveys$sex

sex <- surveys$sex #We can even save our extracted column into a new object. This one will be a "vector," a 1 dimensional object (no rows or columns, just a string of values)
sex[56] #For vectors, no rows or columns, so just a single number needed to index.
sex[572]

c(8, 75, 450) #The c function can be used to make a new vector of whatever values we want.
vec1 <- c(8, 75, 450) #Store our new vector in an object.
sex[vec1] #Then use that vector we made to index values out of sex.
sex[c(8,75,450)] #We don't need to do that in two steps--we could just put the c function inside of the square brackets. R will do operations from the inside outward. 

1:10 #Demonstrate the : operator for making sequences.
10:1 #It will go backwards also.
sex[50:45] #This can be used to index as well.

vec2 = seq(from=5, to=20, by = 5) #The seq function will make more complex sequences, if you're interested.
sex[vec2] #These can also be used to extract specific values.

vec1[-2] #The - sign will exclude the values listed instead of including them. "Not the 2nd value"

surveys[1:3, 7] #All these indexing tricks also work on data frames, so long as we have the comma to separate rows from columns.
surveys[c(1,4,5), -7]

surveys_last <- surveys[nrow(surveys),] #Answer to the 2nd optional challenge. This will save just the last row of surveys into a new object.

heights <- c(2, 4, 6, NA, 10) #R works well with missing data. Let's show how by making a vector that has an NA value.
mean(heights) #We don't get back an average, just NA!
range(heights)
mean(heights, na.rm=TRUE) #By using the na.rm argument, we can get rid of those NAs and take the mean as normal.
range(heights, na.rm=T) #Show that T works as a substitute for TRUE.

mean(heights, TRUE) #Why doesn't this work? Because na.rm is the third argument in mean, not the second. R is trying to put it in the second argument's slot, though, which it can't do in this case. So, to skip the second argument, we had to tell R we were trying to change just the third one.

is.na(heights) #Returns TRUE for all missing values.
heights[is.na(heights)] #Will extract all missing values from an object.
heights[!is.na(heights)] #The ! will make R instead extract all the NON-missing values from the object, so this can be used to remove missing values!
na.omit(heights) #This function will also do that.

##Factors are special ways of handling categorical data in R. Let's make one.
sex <- factor(c("male", "female", "female", "male"))
str(sex) #Factor with two levels, female and male, and then numerical data. It's a hybrid!

#Female was first alphabetically, so it was assigned the first level. To change that, we can use the levels argument to specify a different order.
sex1 <-factor(sex, levels=c("male", "female"))
str(sex1) #This reversed the order.

#R is clumsy when you make a factor out of data that looks like numbers. Let's see how.
fac1 <- factor(c(1,50,10,2)) #Factor of numbers.
str(fac1)
as.character(fac1) #This will convert the factor into text categories.
as.numeric(fac1) #But this WON'T turn the factor back into the original numbers! 
as.numeric(as.character(fac1)) #This is the workaround--first to text, then to numbers.

table(sex) #Showcase the table function for counting up how many of each factor you have quickly.
table(surveys$sex)

#We can prevent R from turning our text columns into factors automatically by using the stringsAsFactors argument inside of read.csv.
surveys_chr <- read.csv("raw_data/portal_data_joined.csv", stringsAsFactors = FALSE)
str(surveys_chr) #Shows that this works.
