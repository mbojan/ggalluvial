# basic flows (alluvia)
ggplot(as.data.frame(Titanic),
       aes(weight = Freq, axis1 = Class, axis2 = Sex)) +
    geom_alluvium()

# use of aesthetics
ggplot(as.data.frame(Titanic),
       aes(weight = Freq,
           axis1 = Class, axis2 = Sex, axis3 = Age, axis4 = Survived)) +
    geom_alluvium(aes(fill = Age, alpha = Sex, color = Survived)) +
    scale_color_manual(values = c("black", "white"))

# use of facets
ggplot(as.data.frame(Titanic),
       aes(weight = Freq,
           axis1 = Class, axis2 = Sex, axis3 = Age)) +
    geom_alluvium(aes(fill = Age, alpha = Sex)) +
    facet_wrap(~ Survived, scales = "free_y")

# use of groups (needs to be prohibited)
ggplot(as.data.frame(Titanic),
       aes(weight = Freq, axis1 = Class, axis2 = Sex, group = Survived)) +
    geom_alluvium()

# degeneracy (one axis)
ggplot(as.data.frame(Titanic), aes(weight = Freq, axis = Class)) +
    geom_alluvium(aes(fill = Class, color = Survived)) +
    scale_color_manual(values = c("black", "white"))

# degeneracy (no axis)
if (FALSE) {
    ggplot(as.data.frame(Titanic), aes(weight = Freq)) +
        geom_alluvium(aes(fill = Class, color = Survived)) +
        scale_color_manual(values = c("black", "white"))
}

# control of horizontal spacing
ggplot(as.data.frame(Titanic),
       aes(weight = Freq,
           axis1 = Class, axis2 = Sex, axis3 = Age, axis4 = Survived)) +
    geom_alluvium(aes(fill = Age, alpha = Sex),
                  axis_width = 1/5, ribbon_bend = 1/3)

# control of axis positions (ridiculous syntax)
ggplot(as.data.frame(Titanic),
       aes(weight = Freq,
           axis1 = Class, axis1.5 = Age, axis2.5 = Sex, axis3 = Survived)) +
    geom_alluvium(aes(fill = Age, alpha = Sex))

# use of annotation and labels
ggplot(as.data.frame(Titanic),
       aes(weight = Freq, axis1 = Class, axis2 = Sex, axis3 = Age)) +
    geom_alluvium() +
    geom_text(stat = "stratum") +
    ggtitle("Alluvial diagram of Titanic passenger demographic data") +
    scale_x_continuous(breaks = 1:3, labels = c("Class", "Sex", "Age"))

# combining flows and boxes
ggplot(as.data.frame(UCBAdmissions),
       aes(weight = Freq, axis1 = Gender, axis2 = Dept)) +
    geom_alluvium(aes(fill = Admit)) +
    geom_stratum() + geom_text(stat = "stratum")

# combining flows and boxes and using facets
ggplot(as.data.frame(UCBAdmissions),
       aes(weight = Freq, axis1 = Dept, axis2 = Admit)) +
    geom_alluvium() +
    geom_stratum() + geom_text(stat = "stratum") +
    facet_wrap(~ Gender, scales = "free_y")

# omitting weight (defaults to 1)
ggplot(as.data.frame(Titanic),
       aes(axis1 = Class, axis2 = Sex)) +
    geom_alluvium() +
    geom_stratum() + geom_text(stat = "stratum")
