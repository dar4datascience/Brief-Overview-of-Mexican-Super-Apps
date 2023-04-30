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
  ) %>% 
  add_title(
    title = 'Comparison Super Apps'
  )