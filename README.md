## daysuntil

A simple bash script to calculate the number of days, years, months etc. until a target date or between two dates 

### Usage

`daysuntil <date> [<from date>]`

If only one date is provided, the script will output the number of days, years, months, weeks, hours, minutes and seconds until or how long ago the target date was.

If a second date is provided, the script will instead output the difference between the two dates.

Date supports any date format that `date` can parse, e.g. `2024-05-11`, `17 April 2023`, `tomorrow`, `next friday`. Specific time can also be specified.

### Dependencies

- `bash`
- `date`
- `bc`

### License

MPL-2.0
