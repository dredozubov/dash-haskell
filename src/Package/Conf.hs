module Package.Conf where

import qualified Filesystem.Path.CurrentOS as P
import           PackageKey

data Conf = Conf
  { pkg           :: PackageKey
  , interfaceFile :: P.FilePath -- interface, i.e. .haddock file
  , htmlDir       :: P.FilePath -- root html source directory
  , exposed       :: Bool       -- module exposure flag
  }
