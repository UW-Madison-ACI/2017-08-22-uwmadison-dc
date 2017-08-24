#Download the file to work with.
download.file("http://kbroman.org/datacarp/portal_data_reduced.csv", "raw_data/portal_data_reduced.csv")
reduced <- read.csv("raw_data/portal_data_reduced.csv") #Save as object called "reduced"

plot() #The base R plotting function (one of them, anyway). Worth learning, but not too powerful.

#Load the libraries needed for this lesson.
library(dplyr)
library(ggplot2) #Can also use packages tab to turn these on.

ggplot(data = reduced, mapping = aes(x=weight, y=hindfoot_length)) #Show that running just this sets up empty graph.

#Add the geom now to graphs the points.
ggplot(data = reduced, mapping = aes(x=weight, y=hindfoot_length)) +
  geom_point()

#We can name parts of the ggplot code so that we can experiment without having to type everything out.
plot1 <- ggplot(data = reduced, mapping = aes(x=weight, y=hindfoot_length)) #Save the base ggplot call into an object.
plot1 + geom_point()

plot2 <- plot1 + geom_point() #Save the whole ggplot + geom into a second object.
plot2

plot2 + scale_y_log10() #Show off different scales. 
plot2 + scale_x_sqrt()
scale_y #Just type to show all the different scales available.


#First challenge solution: Make a new data set with only the rows where species_id is equal to "DM". Then, graph scatterplot as before.
reduced_DM <- reduced %>% filter(species_id == "DM") 
ggplot(reduced_DM, aes(x = weight, y = hindfoot_length)) + geom_point()

#We can change characteristics of individual points by using arguments inside of geom_point()
plot1 + geom_point(alpha = 0.1)
plot1 + geom_point(alpha = 0.1, color="slateblue")
plot1 + geom_point(alpha = 0.1, color="slateblue", size = 0.5)

#We can even make each species have a different colored point using the aes argument here.
plot1 + geom_point(aes(color=species_id))

#Second challenge: Get mean weights, mean foot lengths, and counts for each species. 
#Then, plot weight vs. hindfoot_length, with point size varying by sample sizes.
reduced_means <- reduced %>% group_by(species_id) %>% 
  summarize(weight = mean(weight, na.rm=T), length = mean(hindfoot_length, na.rm=T), count = n())
reduced_means
ggplot(reduced_means, aes(x=weight, y=length)) + geom_point(aes(size=count))

#Line graphs now. New data set of the # of observations by year
yearly_counts <- reduced %>% group_by(year) %>% tally 


plot3 <- ggplot(yearly_counts, aes(x=year, y=n)) #Make base plot and store
plot3 + geom_line() #Add the line geom
plot3 + geom_line() + geom_point() #Add points over top
plot3 + geom_line(color = "violetred") + geom_point(color = "darkblue") #Make the lines and points different colors.
plot3 + geom_point(color = "darkblue") + geom_line(color = "violetred") #Reverse to show that this changes the order in which the geoms are plotted.


plot3 + geom_line() + geom_point(aes(color=year)) #We can set it so only the points differ in color by year.
#Or we can change it so that both the lines and points differ in color by year, this time by making the aesthetic "global" by putting it in the ggplot's aesthetics.
ggplot(yearly_counts, aes(x=year,y=n,color=year)) +
  geom_point() + geom_line()

#Challenge 3: Make the new data sheet that has yearly observation counts for both species DM and DS.
DMDS <- reduced %>% group_by(species_id, year) %>% filter(species_id == "DM" | species_id == "DS") %>% 
tally
#Then plot as a line graph with points added.
ggplot(DMDS, aes(x=year, y=n)) + geom_line() + geom_point()

#Now, that graph didn't look so good. Let's experiment to see if we can get a graph with separate black lines but points that differ for the two species.
ggplot(DMDS, aes(x=year, y=n)) + geom_line() + geom_point(aes(color=species_id)) #This doesn't separate the lines...
ggplot(DMDS, aes(x=year, y=n, color=species_id)) + geom_line() + geom_point() #This does, but now the lines differ in color too.

#To get this to work, we have to "group" the species--telling ggplot that groups (species) should only differ in aesthetics in any specific ways we tell them to. In this case, just their points should differ in color.
ggplot(DMDS, aes(x=year, y=n, group=species_id)) + geom_line() + geom_point(aes(color=species_id))

#Showcase geom_histogram
ggplot(reduced, aes(x=weight)) + geom_histogram() #By default makes 30 bins
ggplot(reduced, aes(x=weight)) + geom_histogram(bins = 8)

#Showcase geom_boxplot
ggplot(reduced, aes(x=species_id, y=hindfoot_length)) + geom_boxplot()
#Showcase geom_jitter, which adds shuffled points on top.
ggplot(reduced, aes(x=species_id, y=hindfoot_length)) + geom_boxplot() + geom_jitter(color="tomato", alpha = 0.3)
#If we reverse the geoms, the points will be below the boxplots instead.
ggplot(reduced, aes(x=species_id, y=hindfoot_length)) + geom_jitter(color="tomato", alpha = 0.3) + geom_boxplot()

#Now, we want to create yet another data set. This time, we want yearly numbers of observations by species.
yearly_counts2 <- reduced %>% group_by(year, species_id) %>% tally

#This makes a line graphs of species counts over time, with each species' line being a different color.
ggplot(yearly_counts2, aes(x=year, y=n, group=species_id, color=species_id)) +
  geom_line()

#Here, though, we use faceting to break the graph into separate graphs, each for a different species. All other aesthetics still apply to the individual facets.
ggplot(yearly_counts2, aes(x=year, y=n, group=species_id, color=species_id)) +
  geom_line() + facet_wrap( ~ species_id)

#What if we wanted different graphs for different species, and different lines for the different sexes within each graph? We need to modify our data set to group by sex as well then.
yearly_counts_sex <- reduced %>% group_by(sex, year, species_id) %>% tally

#Then, we can do that by grouping by sex, coloring by sex, and faceting by species.
ggplot(yearly_counts_sex, aes(x=year, y=n, group=sex, color=sex)) +
  geom_line() + facet_wrap( ~ species_id)

#Facet_grid instead lets you determine how many facets you will get and how they will be arranged. This will make two facets, arranged in rows, with each sex as a row.
ggplot(yearly_counts_sex, aes(x=year, y=n, group=sex, color=sex)) +
  geom_line() + facet_grid(sex ~ .)

#Same, but now the graphs for different sexes will be different columns.
ggplot(yearly_counts_sex, aes(x=year, y=n, group=sex, color=sex)) +
  geom_line() + facet_grid(. ~ sex)

#Now here, each different species will be a row, and sex will be a column.
ggplot(yearly_counts_sex, aes(x=year, y=n, group=sex, color=sex)) +
  geom_line() + facet_grid(species_id ~ sex)

plot2 #Returning to this scatterplot to illustrate some further customization options.
plot2 + scale_y_continuous(limits=c(15, 45)) #This will change what range of Y data will be shown
plot2 + scale_x_continuous(breaks=c(0, 5, 25, 50, 150)) #This will change what labels go on the X axis.

plot2 + aes(color=sex) #What if you don't like the default colors?
plot2 + aes(color=sex) + scale_color_manual(values=c("blue", "yellow2")) #You can change them using scale_color_manual's argument "values" to whatever colors you want.

plot2 + theme(panel.background = element_rect(fill ="white")) #If you hate the default gray background, you can change it to white.
plot2 + theme(panel.grid = element_blank()) #If you hate the default grid lines, you can suppress them.
plot2 + theme_bw() #There are also themes available, like this one which is a standard black and white theme.
theme_ #Show the other theme options.

#Using ggsave to save graphs into our output folder.
ggsave("output/scatter.png", plot2, height=6, width=8)
ggsave("output/scatter.pdf", plot2, height=6, width=8)
