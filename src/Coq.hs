module Coq where

import Control.Monad.IO.Class
import Language.Haskell.Meta.Parse
import Language.Haskell.TH
import Language.Haskell.TH.Quote
import System.Exit
import System.IO
import System.IO.Temp
import System.Process

coq :: QuasiQuoter
coq = QuasiQuoter { quoteDec = quoter }

quoter :: String -> Q [Dec]
quoter coqContents = do
  let coqFile = unlines $
        [ "Extraction Language Haskell."
        , coqContents
        ]
  haskellStr <- runIO $ withSystemTempFile "coq_defs.v" $ \filePath handle -> do
    putStrLn $ "path: " ++ filePath
    putStrLn $ "coqFile:\n" ++ coqFile
    hPutStr handle coqFile
    hFlush handle

    (_, Just out, Just err, ph) <-
      createProcess (proc "coqc" [filePath]){std_out = CreatePipe, std_err = CreatePipe}
    ret <- waitForProcess ph
    case ret of
      ExitFailure _ -> do
        -- coqc prints errors to stdout...
        errs <- hGetContents out
        error $ "coqc failed:\n" ++ errs
      ExitSuccess -> do
        haskellStr <- hGetContents out
        putStrLn $ "Generated Haskell:\n" ++ haskellStr
        return haskellStr

  either fail return $ parseDecs haskellStr
