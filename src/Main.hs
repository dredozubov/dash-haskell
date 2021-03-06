import qualified Filesystem.Path.CurrentOS as P
import           Control.Monad.M
import           Pipes
import           Pipes.FileSystem
import           Pipes.Conf
import           Pipes.Db
import           Options.Applicative
import           Options.Documentation
import           Options

import qualified Data.List as L
import           System.Environment

main :: IO ()
main = do 
  -- Check for help mode arg first. There doesn't seem to be a good way to do this
  -- otherwise with opt-parse applicative.
  args <- getArgs
  case L.partition (== "help") args of 
    ([], args') -> do
      options <- handleParseResult $ execParserPure (prefs idm) parserInfo args'
      
      -- Run the package processing pipeline. Packages that can't be completed due
      -- to either conversion error or user error, should, if necessary, leave a safe partially
      -- completed state on the FS that can be handled by dependant tools, e.g. Emacs helm-dash.

      runM (newEnv (not . quiet $ options)) . runEffect $
       cons_writeFiles (P.decodeString $ outputDir options) -- writes converted html, haddock, and sql db
       <-< pipe_Conf              -- yields vetted package configurations
       <-< pipe_ConfFp (dbprovider options)  -- yields GHC package config files
       <-< prod_Packages options
    (_, rest) -> toHelp docs rest
  
  where 
   parserInfo :: ParserInfo Options
   parserInfo = info (helper <*> parser)  $
     header "dash-haskell v1.0.0.4, a dash docset construction tool for Haskell packages"
     <> progDesc "additional help is available with \"dash-haskell help <topic|option>\""
     <> footer "http://www.github.com/jfeltz/dash-haskell (C) John P. Feltz 2014"
