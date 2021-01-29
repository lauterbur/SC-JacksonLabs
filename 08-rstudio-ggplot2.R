# ggplot2 is built on the grammar of graphics, the idea that any plot can be
# expressed from the same set of components: a **data** set, a
# **coordinate system**, and a set of **geoms** -- the visual representation of data
# points.
# 
# The key to understanding ggplot2 is thinking about a figure in layers.
# This idea may be familiar to you if you have used image editing programs like Photoshop, Illustrator, or
# Inkscape.
# 
# We're going to be working in the same project we made yesterday, so
# make sure you have opene it by going to File -> Open Project.
# 
# First, make sure you have loaded the libraries and data we're going to need:
#   
library(ggplot2)
library(dplyr)
head(gapminder)

# Let's start off with an example:

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# So the first thing we do is call the `ggplot` function. This function lets R
# know that we're creating a new plot, and any of the arguments we give the
# `ggplot` function are the *global* options for the plot: they apply to all
# layers on the plot.
# 
# We tell it the data set we want it to use and how the data maps to the 
# aesthetic properties of the figure - this includes what columns should 
# be used for each axis, but can also include properties such as
# colors and groupings of the data, which we'll see later.
# 
# Here we told `ggplot` we
# want to plot the "gdpPercap" column of the gapminder data frame on the x-axis, and
# the "lifeExp" column on the y-axis. Notice that we didn't need to explicitly
# pass `aes` these columns (e.g. `x = gapminder[, "gdpPercap"]`), this is because
# `ggplot` is smart enough to know to look in the **data** for that column!
#   
#   By itself, the call to `ggplot` isn't enough to draw a figure:

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp))

# We need to tell `ggplot` how we want to visually represent the data, which we
# do by adding a new geom layer. In our example, we used `geom_point`, which
# tells `ggplot` we want to visually represent the relationship between x and
# y as a scatterplot of points:

ggplot(data = gapminder, mapping = aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

# The beauty of this is that we can just keep adding layers to adjust the plot.
# We don't need to rewrite the whole plot each time.
# 
# From here, we're going to use some tricks from dplyr to make our
# ggplot code more streamlined, with pipes %>%

gapminder %>% ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()

## Challenge 1

# Modify the ggplot function in the example so that the figure shows how life expectancy has
# changed over time. First take a look at the gapminder dataset to
# remind yourself what variables it has and what they're called. You can
# do this in a few different ways:

head(gapminder)
str(gapminder)
names(gapminder)

# This is what you want to modify:
gapminder %>%
 ggplot(aes(x = gdpPercap, y = lifeExp)) + 
 geom_point()

# Here's something to get you started:
gapminder %>%
  ggplot() +
  geom_point()


## Layers

# Using a scatterplot probably isn't the best for visualizing change over time.
# Instead, let's tell `ggplot` to visualize the data as a line plot. We're going
# to change two things: Instead of adding a `geom_point` layer, we''ve'll add 
# a `geom_line` layer. We'll also add the by aesthetic, which tells 
# `ggplot` to draw a line for each country.

gapminder %>%
  ggplot(aes(x=year, y=lifeExp, by=country, color=continent)) +
  geom_line()


# You can find more geom options by using `??geom_` or (since the double
# question mark search isn't working for everyone), searching in the help panel
# for "geom_" The double questionmark is a known bug in Rstudio - it's fixed
# in newer versions.
# 
# But what if we want to visualize both lines and points on the plot? We can
# add another layer to the plot:

gapminder %>%
  ggplot(aes(x=year, y=lifeExp, by=country, color=continent)) +
  geom_line() + 
  geom_point()


# Another way to do this would have been to store the initial gplot in an object:
p <- gapminder %>%
  ggplot(aes(x=year, y=lifeExp, by=country, color=continent)) +
  geom_line()
p


# And then add the new layer to that object:
p + geom_point()

# It's important to note that each layer is drawn on top of the previous layer. In
# this example, the points have been drawn on top of the lines. Here's a
# demonstration:

gapminder %>% 
  ggplot(aes(x=year, y=lifeExp, by=country)) +
  geom_line(mapping = aes(color=continent)) + 
  geom_point()


# In this example, the aesthetic mapping of color has been moved from the
# global plot options in `ggplot` to the `geom_line` layer so it only applies
# to the lines, and no longer applies
# to the points. Now we can clearly see that the points are drawn on top of the
# lines.
# 
# Black is the default color. If instead we want the points to be white, we might
# try

gapminder %>% 
  ggplot(aes(x=year, y=lifeExp, by=country)) +
  geom_line(mapping = aes(color=continent)) + 
  geom_point(mapping = aes(color="white"))


# That didn't work, because ggplot thinks we're trying to map the color to a variable called "white."
# (You can see it at the end of the legend.)
# Instead, we need to move it outside the aesthetic mapping part of the function:

gapminder %>% 
  ggplot(aes(x=year, y=lifeExp, by=country)) +
  geom_line(mapping = aes(color=continent)) + 
  geom_point(color="blue")

# Since each geom is a new layer, what do you think will happen if you switch the order of
# geom_point and geom_line in the previous example? Take a moment to think about it...

gapminder %>% 
  ggplot(aes(x=year, y=lifeExp, by=country)) +
  geom_point(color="blue") +
  geom_line(mapping = aes(color=continent))

## Transformations and statistics

# ggplot2 also makes it easy to overlay statistical models over the data, without
# needing to do the transformations yourself first. To
# demonstrate we'll go back to our first example:
  
gapminder %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point()


# Currently it's hard to see the relationship between the points due to some strong
# outliers in GDP per capita. We can change the scale of units on the x axis using
# the *scale* functions. These control the mapping between the data values and
# visual values of an aesthetic. 

gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10()

# The `log10` function applied a transformation to the values of the gdpPercap
# column before rendering them on the plot.
# You can find more scale options by using `??scale_` or (since the double
# question mark search isn't working for everyone), searching in the help panel
# for "scale_"
# 
# We can also modify the transparency of the
# points, using the alpha function, which is especially helpful when you have
# a large amount of data which is very clustered. 

gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(alpha = 0.5) + 
  scale_x_log10()

# Notice that we used `geom_point(alpha=0.5)` with alpha outside `aes()`.
# This changed the alpha value for all points, but we could have mapped it to
# a variable, for example:
  
gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point(aes(alpha = continent)) + 
  scale_x_log10()

# It complains because that's really hard to read, and Hadley Wickham has strong
# opinions on what makes a good plot (and he's usually right). ggplot wants
# to help you make good plots. But it does let you do it.
# 
# We can easily fit a simple linear model to the data by adding another layer,
# `geom_smooth`:

gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10() + 
  geom_smooth(method="lm")


# We can see what other models geom_smooth can fit by looking at the help page,
# `help(geom_smooth)`
# 
# We can make the line thicker by setting the size aesthetic in the
# `geom_smooth` layer:

gapminder %>%
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  geom_point() + 
  scale_x_log10() + 
  geom_smooth(method="lm", size=1.5)

# Challenge: 
# How would you modify this to give the points for each contient a different color?
# Here's something to get you started:

gapminder %>% 
  ggplot(aes()) +
  geom_point() + 
  scale_x_log10() +
  geom_smooth(method="lm", size=1.5)


## Multi-panel figures

# Earlier we visualized the change in life expectancy over time across all
# countries in one plot. Alternatively, we can split this out over multiple panels
# by adding a layer of facet panels.
# 
# To simplify, we're going to do this just for the countries in the Americas,
# using a dplyr trick to separate them out:

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) 

# The `facet_wrap` layer is what's doing the work here. It takes a "formula" 
# as its argument, denoted by the tilde (~). This tells R to draw a panel (facet) for 
# each unique value in the country column of the data you gave it. 
# 
# That's great, but the x axes are pretty hard to read.
# 
# `facet_wrap` has a lot of customization options that you can see in the
# help page, for now let's see if changing the number of columns helps
# with our axis problem:

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp)) +
  geom_line() %>%
  facet_wrap( ~ country,ncol=3) 

# Here I've shown you an error you are likely to make at some point, but is
# really hard to figure out because the error message isn't directly addressing
# the issue. 
# 
# Challenge:
# Take a look at that bit of code and try to figure out what I did wrong.


# Let's fix that and look at the plot with 3 columns:
gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp)) +
    geom_line() +
    facet_wrap( ~ country,ncol=3) 

# It fixes the x-axis issue... but makes the rest worse. Seems like facet_wrap did a good job of
# deciding the number of columns for us. Instead, we're going to
# try the `theme` layer to angle the x-axis labels.

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp)) +
  geom_line() +
  facet_wrap( ~ country) +
  theme(axis.text.x = element_text(angle = 45))

## Modifying text

# To clean this figure up for a publication we need to change some of the text
# elements. The x-axis is too cluttered, and the y axis should read
# "Life expectancy", rather than the column name in the data frame.
# 
# We can do this by adding a couple of different layers. The theme layer
# controls the axis text, and overall text size. Labels for the axes, plot
# title and any legend can be set using the `labs` layer. Legend titles
# are set using the same names we used in the `aes` specification. Thus below
# the color legend title is set using `color = "Continent"`.

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp, color=continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Now, I and most people I work with default theme for ggplots, the grey background
# with white grid, to be pretty ugly. We can change that to something less obtrusive.

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp, color=continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  theme_bw()

# You can search `theme_` to see other complete theme options.
# 
# But what happened to my previous tweaks? Remember that ggplot layers are ordered - when
# I added `theme_bw()` after the modifications in `theme` it went back to the text defaults.

gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp, color=continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

## Exporting the plot

# The `ggsave()` function allows you to export a plot created with ggplot. 
# You can specify the dimension and resolution of your plot by adjusting the appropriate arguments 
# (`width`, `height` and `dpi`) to create high quality graphics for publication.
# In order to save the plot from above, we first assign it to a variable `lifeExp_plot`, 
# then tell `ggsave` to save that plot in `png` format to a directory called `results`. 
# (Make sure you have a `results/` folder in your working directory. You can check using the "Files" 
# tab on the bottom right pane in Rstudio.)

lifeExp_plot <- gapminder %>%
  filter(continent=="Americas") %>%
  ggplot(aes(x=year,y=lifeExp, color=continent)) +
  geom_line() + 
  facet_wrap( ~ country) +
  labs(
    x = "Year",              # x axis title
    y = "Life expectancy",   # y axis title
    title = "Figure 1",      # main title of figure
    color = "Continent"      # title of legend
  ) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

ggsave(filename="lifeExp.png")

# Let's take a look and see how it saved. It's okay, but some of the facet labels are cut off. In
# addition, the resolution doesn't look great. 
# `ggsave` defaults to the last plot, which is why we
# didn't have to tell it what plot to save, but it also defaults to use the current size of the
# plot display. So this time we're going to tell it explicitly how big to make the plot, as
# well as which plot to save:

ggsave(filename = "lifeExp.png", plot = lifeExp_plot, width = 20, height = 15, dpi = 300, units = "cm")

# Another nice thing it's doing is that it tries to figure out the format you want to save 
# your plot in from the file extension you provide for the filename (for example `.png` or `.pdf`). 
# If you need to, you can specify the format explicitly in the `device` argument.

## Challenge

# Generate boxplots to compare life expectancy between the different continents during the available years.
# Use a geom that summarizes data within categories rather than just points or lines. Remember that you can 
# use `??geom_` or search "geom_" in the help page search box to find options.
# 
# Advanced:
#  - Rename y axis as Life Expectancy.
#  - Remove x axis labels.
#  - Use just data after 1980.
