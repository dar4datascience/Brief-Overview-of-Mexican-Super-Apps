library(tesseract)
library(dplyr)
eng <- tesseract("eng")
text <- tesseract::ocr("inputs/chinese_super_app_comparison.png", engine = eng)
cat(text)

text_df <- stringr::str_split(text, "\n") %>% 
  purrr::pluck(1)

clean_text_df <- text_df[5:16] %>% 
  tibble() %>% 
  rename(
    'Lifestyle features' = "."
  ) %>% 
  mutate(
    number_of_vs = stringr::str_extract_all(`Lifestyle features`, "[vV]") %>% 
      purrr::map(.,
        ~glue::glue_collapse(.x) %>% 
      stringr::str_length(.)
      ) ,
    wechat = if_else(number_of_vs > 0,"Yes", " "),
    alibaba = if_else(number_of_vs > 1,"Yes", " "),
    meituan = if_else(number_of_vs > 2 , "Yes", " ")
  ) %>% 
  select(!number_of_vs)


write.csv(clean_text_df, "chinese_companies_superapps_servicies_dirty.csv")
