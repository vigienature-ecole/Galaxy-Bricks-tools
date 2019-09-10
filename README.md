# Galaxy-Bricks

The Galaxy-Bricks project is part of is part of the european project GAPARS (Horizon 2020 research and innovation programme under grant agreement Nr 732703). It aims to fill a gap in our citizen science programs which, historically were focusing on data collection. In the last decade, however, they have broaden their scope and education became a major component of these programs. Education to scientific approach in the context of citizen science is extremely promising. The participants follow the protocols and develop a knowledge or even an expertise in the field they are contributing to (e.g. species identification). The data collected allow research teams to perform data analyses on the large datasets, which are needed to document the changes biodiversity is facing (e.g. anthropisation, global changes).
To increase the accessibility to data and extend collaborations between research teams and participants, we are developing Galaxy-Bricks, a data analysis tool based on Galaxy for ecology. This platform should include user-friendly tools together with specific training material, designed for a non-professional contributors. We are using the possibilities that Galaxy provides to reach this goal and we are investigating ergonomic improvement of the graphical user interface using notably external softwares.
On his educational side, this project will provide a concrete tool to develop data literacy, favor open data and collaboration in our communities.

## Tool development

- we are developing intuitive tools to analyze data.
  - anova (analysis of variance)
    - TODO: find possibility to change order (impossible with the data_column parameter)
    - TODO: be more picky with the interactions (only all or none for now)
  - linear regression
  - datamash
    - TODO: keep original names
  - join datasets
    - TODO keep header
    - TODO select column to keep for datasets

### Tool list

Tool name | Functional tool | tests | help
---------------------------------------------
- Import data | WIP | no | WIP
- Column simple operation  | YES | no | no
- Row simple operation | YES | no | no
- Select lines | YES | no | no
- Select columns | YES | no | no
- Plot | YES | no | no
- anova | YES | no | no
