library(googlesheets4)
library(dplyr)
library(reactablefmtr)

#Auth
gs4_auth(email='danielamieva@dar4datasience.com')

sa_tbl_comparison <- read_sheet("https://docs.google.com/spreadsheets/d/1dwy5UQF5mwj4LQlk-gUKR9eojDe2njBUfjHURhrfOQE/edit#gid=409865214")  %>% 
   mutate(
    across(!`Lifestyle features`,
           ~if_else(.x == "Yes",
                    '✅',  # checkmark for 100%
                    " "                    )
             )

   )

sa_tbl_comparison %>%
  reactable(
    theme = pff(centered = TRUE),
    defaultPageSize = 12,
    columns = list(`Lifestyle features` = colDef(minWidth = 400))
  )



sa_tbl_comparison %>% 
  reactable(
    theme = pff(centered = TRUE),
    defaultColDef = colDef(footerStyle = list(fontWeight = "bold"),
                           cell = pill_buttons(
                             data = .,
                             color_ref = 'colors',
                             box_shadow = TRUE
                           )),
    columns = list(
      colors = colDef(show = FALSE)
    )
  ) %>% 
  add_title(
    title = 'Comparison Super Apps'
  )


data <- tribble(
  ~name,~date,~location,~units,~amount,~avg_unit,~status,~colors,
  'John','2022-03-05','Seattle',40,10000,250,'Approved','lightgreen',
  'Jane','2022-04-01','Denver',20,15000,750,'Pending Approval','gold1',
  'Luke','2022-03-31','Austin',15,8000,533,'Approved','lightgreen',
  'Mary','2022-03-28','New York',25,21000,840,'Cancelled','lightpink',
  'Peter','2022-04-05','Miami',10,17000,1700,'Pending Approval','gold1',
  'Paul','2022-03-22','Los Angeles',30,12000,400,'Approved','lightgreen'
)

data %>% 
  reactable(
    theme = pff(centered = TRUE),
    defaultColDef = colDef(footerStyle = list(fontWeight = "bold")),
    columns = list(
      name = colDef(
        minWidth = 175,
        footer = 'Total',
        cell = merge_column(
          data = .,
          merged_name = 'location',
          merged_position = 'below',
          merged_size = 14,
          size = 16,
          color = '#333333',
          spacing = -1
        )
      ),
      date = colDef(
        minWidth = 125,
        cell = pill_buttons(
          data = .,
          opacity = 0.8
        )
      ),
      location = colDef(show = FALSE),
      units = colDef(footer = function(values) scales::label_number()(sum(values))),
      amount = colDef(
        cell = function(value) {scales::label_dollar()(value)},
        footer = function(values) scales::label_dollar()(sum(values))),
      avg_unit = colDef(
        name = 'Avg/Unit', 
        cell = function(value) scales::label_dollar()(value),
        footer = function(values) scales::label_dollar()(mean(values))),
      status = colDef(
        minWidth = 175,
        cell = pill_buttons(
          data = .,
          color_ref = 'colors',
          box_shadow = TRUE
        )
      ),
      colors = colDef(show = FALSE)
    )
  ) %>% 
  add_title(
    title = 'Client Order Summary'
  )