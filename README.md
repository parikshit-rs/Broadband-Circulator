# Design of a Broadband Circulator

## Objectives
- To design a broadband circulator in CST Studio Suite that works around 3.45 GHz.
- To obtain the S-parameters of the designed circulator and match terminate the ports.

## Introduction
A broadband circulator is an essential component in many microwave systems and communication devices. It is a passive, three-port device that allows microwave signals to flow in a specific direction and blocks signals flowing in the opposite direction. This property makes it an important tool in isolating and protecting sensitive components in microwave systems, as well as enabling signal routing and power distribution.

The design of a broadband circulator is a complex task that requires a thorough understanding of electromagnetic theory and materials science. The objective of this project is to design a broadband circulator using the CST Studio Suite software and yttrium iron garnet (YIG) material. YIG is a common choice for circulator applications due to its high magnetic permeability and low magnetic damping, which allows for a wide operating bandwidth.

The design of a broadband circulator involves optimizing a range of parameters, such as the geometry of the ferrite material, the placement of the input/output ports, and the choice of operating frequency. The goal is to achieve a high level of isolation between the input and output ports over a wide range of frequencies, while minimizing losses and maximizing power handling capability.

This project aims to provide a detailed analysis of the design process for a broadband circulator, including the theoretical background, numerical simulation using CST Studio Suite, and practical considerations for fabrication and testing. By gaining a deeper understanding of the design principles and techniques for broadband circulators, this project can contribute to the development of more efficient and reliable microwave systems for a range of applications.

## What is a circulator?
A broadband circulator is a passive three-port device that allows microwave signals to flow in a specific direction and blocks signals flowing in the opposite direction. It is a crucial component in many microwave systems and communication devices as it enables signal routing, power distribution, and protection of sensitive components.

The circulator works based on the principle of non-reciprocity, where signals traveling in one direction experience a different transmission path than those traveling in the opposite direction. This property allows the circulator to separate signals traveling in different directions and provide isolation between input and output ports.

There are different types of circulators available, classified based on the frequency range of operation, the type of ferrite material used, and the number of ports. The most common types of circulators are:

1. Waveguide Circulators - These are used in waveguide-based microwave systems and operate in the range of 1 GHz to 100 GHz.

2. Coaxial Circulators - These operate in the frequency range of 10 MHz to 26.5 GHz and are commonly used in microwave systems.

3. Drop-in Circulators - These are compact circulators used in microstrip or stripline circuits and operate in the range of 100 MHz to 20 GHz.

4. Y-junction Circulators - These have a Y-shaped junction that provides isolation between input and output ports and operates in the range of 1 GHz to 20 GHz.

5. Ferrite Junction Circulators - These use ferrite material to provide non-reciprocal behavior and operate in the range of 1 MHz to 100 GHz.

The choice of circulator type depends on the specific application requirements, such as operating frequency, power handling capability, and physical size constraints.

## Design parameters
Design parameters are the variables that affect the performance of the microstrip ferrite circulator. In the research paper "Microstrip Ferrite Circulator Design with Control of Magnetization Distribution," the authors define several important design parameters that need to be considered in the circulator design. These parameters include:

1. Ferrite Disk Size and Shape: The size and shape of the ferrite disk play a significant role in determining the performance of the circulator. The authors optimize the dimensions of the ferrite disk to achieve the desired insertion loss, isolation, and return loss.

2. Bias Magnetic Field: The bias magnetic field is applied to the ferrite disk to magnetize it and enable it to rotate the polarization of the input signal. The authors optimize the strength and direction of the bias magnetic field to achieve the desired performance.

3. Microstrip Line Placement: The placement of the microstrip lines on the ferrite disk is another important design parameter. The authors optimize the position and orientation of the microstrip lines to achieve the desired phase shift and impedance matching.

4. Magnetization Distribution: The magnetization distribution in the ferrite material determines the rotation angle of the polarization of the input signal. The authors propose a method for controlling the magnetization distribution by patterning the ferrite material using a photolithography process.

5. Operating Frequency: The operating frequency of the circulator is an important design parameter. The authors optimize the design to operate at a specific frequency range to achieve the desired performance.

By carefully optimizing these design parameters, the authors were able to design a high-performance microstrip ferrite circulator with low insertion loss, high isolation, and good return loss. The design parameters are critical in determining the performance of the circulator, and they need to be carefully considered during the design and optimization process.

## Methodology 
Ferrite materials are extensively discussed in the literature. The main parameters
given for a commercial ferrite material are magnetization saturation (4πMs usually
in Gauss), ferromagnetic resonant frequency (FMR) linewidth (H in oersted), relative
permittivity (εr), and initial relative permeability (μr).

> We tried the implementation of this project on Stripline as well as Co planar waveguide structures. But unfortunately they were unsuccessful since CST was having internal errors while modeling thus we shifted to the microstrip structure which gave us success in the eighth attempt.

The methodology we developed includes the following steps:

1. Define the center frequency (f): Determine the specific frequency at which the circulator will operate. This frequency is typically based on the requirements of the application or system.

2. Calculate the Larmor frequency (f0): Calculate the Larmor frequency, which is typically set to about 30% above the center frequency. The Larmor frequency is used to determine the required magnetic field strength.

3. Find the required magnetic field (H0): Use the Larmor frequency to calculate the required magnetic field strength (H0) using the equation H0 = f0 / γ, where γ is the gyromagnetic ratio.

4. Determine the magnetization saturation (4πMs): Select ferrite materials that have a magnetization saturation value (4πMs) close to the calculated H0 value. This ensures that the ferrite material can provide the necessary magnetic properties for the circulator.

5. Consider related parameters: Evaluate related parameters such as the difference between coercivity and remanence (ΔH) and the relative permittivity (εr) of the selected ferrite material. These parameters play a role in determining the material's behavior and performance.

6. Calculate the permeability tensor ([μ]): Utilizing the known values of 4πMs, f, and H0, calculate the permeability tensor ([μ]) for the chosen ferrite material. The permeability tensor describes the magnetic properties of the material in different directions.

7. Calculate the effective permeability (μeff): Determine the effective permeability (μeff) from the permeability tensor ([μ]). The effective permeability characterizes the overall magnetic behavior of the material.

8. Determine the dimensions of the circular cavity: For a circulator with a circular cavity design, calculate the radius (rf) using the formula rf = 1.84 / (2πfεμeff). This formula accounts for the desired frequency, effective permeability, and electromagnetic properties of the material. Additionally, calculate the thickness (tf) of the ferrite material, typically set to 0.1 times the radius (tf = 0.1rf).

9. Define the substrate and junction dimensions: Select an appropriate substrate material for the circulator and ensure the junction radius matches the calculated rf. Calculate the dimensions (wi, li) for the case section to achieve a desired 50Ω impedance. These dimensions are critical for proper impedance matching and efficient signal transfer.

10. Perform design optimizations and matching network: Fine-tune the circulator design through optimization techniques, taking into account factors such as impedance matching, bandwidth, isolation, and insertion loss. If necessary, design and incorporate a matching network to ensure proper impedance matching between the circulator and the connected components.

By following this detailed methodology, one can design a broadband circulator with optimized performance characteristics, precise dimensions, and the ability to meet the specific requirements of the application or system.

## Conclusion
Thus, the designed circulator is observed to work well in the frequency range
3.15GHz to 3.65GHz with all the 3 ports matched with referenece impedances
close to 47 ohms.

## References
1. L. Marzall, D. Psychogiou and Z. Popović, "Microstrip Ferrite Circulator
Design With Control of Magnetization Distribution," in IEEE Transactions
on Microwave Theory and Techniques, vol. 69, no. 2, pp. 1217-1226, Feb.
2021, doi: 10.1109/TMTT.2020.3045995.
2. C. E. Fay and R. L. Comstock, "Operation of the Ferrite Junction Circula
tor," in IEEE Transactions on Microwave Theory and Techniques, vol. 13,
no. 1, pp. 15-27, January 1965, doi: 10.1109/TMTT.1965.1125923.
3. Pozar, David M. Microwave Engineering. Hoboken, NJ :Wiley, 2012. APA

For other resources kindly look in Resources folder.
