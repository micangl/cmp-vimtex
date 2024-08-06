"Standard Bibtex keys
syntax match CmpVimtexAddress     "^ADDRESS:\s*"he=e-1
      \ nextgroup=CmpVimtexAddressValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexAddressValue ".*" contained

syntax match CmpVimtexAnnote     "^ANNOTE:\s*"he=e-1
      \ nextgroup=CmpVimtexAnnoteValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexAnnoteValue ".*" contained

syntax match CmpVimtexAuthor     "^AUTHOR:\s*"he=e-1
      \ nextgroup=CmpVimtexAuthorValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexAuthorValue ".*" contained

syntax match CmpVimtexBooktitle     "^BOOKTITLE:\s*"he=e-1
      \ nextgroup=CmpVimtexBooktitleValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexBooktitleValue ".*" contained

syntax match CmpVimtexEmail     "^EMAIL:\s*"he=e-1
      \ nextgroup=CmpVimtexEmailValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexEmailValue ".*" contained

syntax match CmpVimtexChapter     "^CHAPTER:\s*"he=e-1
      \ nextgroup=CmpVimtexChapterValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexChapterValue ".*" contained

syntax match CmpVimtexCrossref     "^CROSSREF:\s*"he=e-1
      \ nextgroup=CmpVimtexCrossrefValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexCrossrefValue ".*" contained

syntax match CmpVimtexDoi     "^DOI:\s*"he=e-1
      \ nextgroup=CmpVimtexDoiValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexDoiValue ".*" contained

syntax match CmpVimtexEdition     "^EDITION:\s*"he=e-1
      \ nextgroup=CmpVimtexEditionValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexEditionValue ".*" contained

syntax match CmpVimtexEditor     "^EDITOR:\s*"he=e-1
      \ nextgroup=CmpVimtexEditorValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexEditorValue ".*" contained

syntax match CmpVimtexHowpublished     "^HOWPUBLISHED:\s*"he=e-1
      \ nextgroup=CmpVimtexHowpublishedValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexHowpublishedValue ".*" contained

syntax match CmpVimtexInstitution     "^INSTITUTION:\s*"he=e-1
      \ nextgroup=CmpVimtexInstitutionValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexInstitutionValue ".*" contained

syntax match CmpVimtexJournal     "^JOURNAL:\s*"he=e-1
      \ nextgroup=CmpVimtexJournalValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexJournalValue ".*" contained

syntax match CmpVimtexKey     "^KEY:\s*"he=e-1
      \ nextgroup=CmpVimtexKeyValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexKeyValue ".*" contained

syntax match CmpVimtexMonth     "^MONTH:\s*"he=e-1
      \ nextgroup=CmpVimtexMonthValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexMonthValue ".*" contained

syntax match CmpVimtexNote     "^NOTE:\s*"he=e-1
      \ nextgroup=CmpVimtexNoteValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexNoteValue ".*" contained

syntax match CmpVimtexNumber     "^NUMBER:\s*"he=e-1
      \ nextgroup=CmpVimtexNumberValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexNumberValue ".*" contained

syntax match CmpVimtexOrganization     "^ORGANIZATION:\s*"he=e-1
      \ nextgroup=CmpVimtexOrganizationValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexOrganizationValue ".*" contained

syntax match CmpVimtexPages     "^PAGES:\s*"he=e-1
      \ nextgroup=CmpVimtexPagesValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexPagesValue ".*" contained

syntax match CmpVimtexPublisher     "^PUBLISHER:\s*"he=e-1
      \ nextgroup=CmpVimtexPublisherValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexPublisherValue ".*" contained

syntax match CmpVimtexSchool     "^SCHOOL:\s*"he=e-1
      \ nextgroup=CmpVimtexSchoolValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexSchoolValue ".*" contained

syntax match CmpVimtexSeries     "^SERIES:\s*"he=e-1
      \ nextgroup=CmpVimtexSeriesValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexSeriesValue ".*" contained

syntax match CmpVimtexTitle     "^TITLE:\s*"he=e-1
      \ nextgroup=CmpVimtexTitleValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexTitleValue ".*" contained

syntax match CmpVimtexType     "^TYPE:\s*"he=e-1
      \ nextgroup=CmpVimtexTypeValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexTypeValue ".*" contained

syntax match CmpVimtexVolume     "^VOLUME:\s*"he=e-1
      \ nextgroup=CmpVimtexVolumeValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexVolumeValue ".*" contained

syntax match CmpVimtexYear     "^YEAR:\s*"he=e-1
      \ nextgroup=CmpVimtexYearValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexYearValue ".*" contained

"Biblatex
syntax match CmpVimtexIsbn     "^ISBN:\s*"he=e-1
      \ nextgroup=CmpVimtexIsbnValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexIsbnValue ".*" contained

syntax match CmpVimtexIssn     "^ISSN:\s*"he=e-1
      \ nextgroup=CmpVimtexIssnValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexIssnValue ".*" contained

"cmp-vimtex-specific keys
syntax match CmpVimtexFile     "^VIMTEX_FILE:\s*"he=e-1
      \ contains=CmpVimtexColon
syntax match CmpVimtexFileValue ".*" contained

syntax match CmpVimtexLnum     "^VIMTEX_LNUM:\s*"he=e-1
      \ nextgroup=CmpVimtexLnumValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexLnumValue ".*" contained

syntax match CmpVimtexCite     "^CITE_KEY:\s*"he=e-1
      \ nextgroup=CmpVimtexCiteValue
      \ contains=CmpVimtexColon
syntax match CmpVimtexCiteValue ".*" contained

syntax match CmpVimtexColon ":" contained

"Address
"Annote
"Author
"Booktitle
"Email
"Chapter
"Crossref
"Doi
"Edition
"Editor
"Howpublished
"Institution
"Journal
"Key
"Month
"Note
"Number
"Organization
"Pages
"Publisher
"School
"Series
"Title
"Type
"Volume
"Year

"hi def link CmpVimtexType RedrawDebugClear
