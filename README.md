Quantifying the contribution of individual muscles during human locomotion is still widely discussed in the literature to date: since the musculoskeletal system of man consists of a greater number of muscles than its degrees of freedom, it is difficult to decompose the moment in the individual muscle contributions.

The purpose of this work is therefore first of all to implement an optimization method aimed at estimating the muscular forces for the lower limbs during human locomotion, on a flat surface, quantifying the reliability of the solutions found by comparing them with data. obtained at the electromyographic examination performed during the motor act.

The analysis was carried out on the basis of data in a database of 50 subjects, processed at the Movement Analysis Laboratory (LAM) of the Don Carlo Gnocchi Foundation Scientific Institute in Milan.

The implementation of the Min / Max (even soft saturation & polynomial methods are present in those file) optimization method was carried out through MA TLAB®.

The raw data present in the database, relating to the electromyographic signal, has been filtered to suppress motion artifacts and other possible interferences.

The degrees of similarity between the calculated forces are thus compared with the linear envelope of the EMG signal, measured on the reference muscle, in order to obtain as much confirmation as possible of the validity of the method used.

The comparison was made using a Matlab cross correlation function, considering the maximum peak returned by this function.

To assess whether it was possible to carry out a classification using machine learning, the accuracy of classification on multiple algorithms in parallel (for a total of 24) was evaluated using Matlab Classification Learner(not present in those file).

Optimization.m

INPUT (SUBJECT [1:50], TRIAL[1:N], OPTIMIZATION METHOD)

OUTPUT (SOLUTION FROM OPTIMIZATION [MUSCLE IN THE MODEL], SOLUTION COMPARED WITH LINEAR ENVELOP OF EMG SIGNAL).
