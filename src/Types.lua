export type Executable = {
  Name: string,
  Side: string,
}

export type Importable = {
  OnImport: () -> any?,
  Importable: boolean?,
}

return nil