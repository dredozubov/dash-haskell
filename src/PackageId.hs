module PackageId where
import qualified Distribution.Package as C
import qualified Distribution.Version as CV

emptyVersion :: CV.Version
emptyVersion = CV.Version [] []
              
unversioned :: C.PackageId -> C.PackageId
unversioned p = p { C.pkgVersion = emptyVersion } 
