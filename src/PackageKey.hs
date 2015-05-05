{-# LANGUAGE CPP #-}

module PackageKey where

import qualified Distribution.Package as C
import qualified Distribution.Version as CV
import qualified Module as Ghc

#if MIN_VERSION_base(4,8,0)
type PackageKey = Ghc.PackageKey
#else
type PackageKey = Ghc.PackageId
#endif

packageKeyString :: PackageKey -> String
#if MIN_VERSION_base(4,8,0)
packageKeyString = Ghc.packageKeyString
#else
packageKeyString = Ghc.packageIdString
#endif

emptyVersion :: CV.Version
emptyVersion = CV.Version [] []
              
unversioned :: C.PackageId -> C.PackageId
unversioned p = p { C.pkgVersion = emptyVersion } 
