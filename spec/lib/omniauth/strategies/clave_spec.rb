# frozen_string_literal: true

require "spec_helper"
require "omniauth/strategies/clave"

RSpec.describe OmniAuth::Strategies::Clave do
  # subject is what the app responds
  subject { strategy.call(env) }

  let!(:organization) { create(:organization) }

  let(:strategy) do
    described_class.new(app,
                        "CLIENT_ID",
                        "CLIENT_SECRET",
                        "https://clave.example.es", {})
  end
  let(:app) do
    lambda do |env|
      [200, {}, [env["omniauth.auth"]]]
    end
  end
  let(:env) do
    {
      "HTTP_HOST" => organization.host,
      "rack.session" => {},
      "SCRIPT_NAME" => "",
      "PATH_INFO" => "/users/auth/clave/callback",
      "rack.input" => true,
      "rack.request.form_input" => true,
      "rack.request.form_hash" => { "SAMLResponse" => saml_response },
      "omniauth.strategy" => strategy
    }
  end
  let(:saml_response) do
    # rubocop: disable Layout/LineLength
    "PHNhbWwycDpSZXNwb25zZSB4bWxuczpzYW1sMnA9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpwcm90b2NvbCIgeG1sbnM6ZHM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiIHhtbG5zOmVpZGFzPSJodHRwOi8vZWlkYXMuZXVyb3BhLmV1L2F0dHJpYnV0ZXMvbmF0dXJhbHBlcnNvbiIgeG1sbnM6ZWlkYXMtbmF0dXJhbD0iaHR0cDovL2VpZGFzLmV1cm9wYS5ldS9hdHRyaWJ1dGVzL25hdHVyYWxwZXJzb24iIHhtbG5zOnNhbWwyPSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXNzZXJ0aW9uIiB4bWxuczp4cz0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEiIENvbnNlbnQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpjb25zZW50Om9idGFpbmVkIiBEZXN0aW5hdGlvbj0iaHR0cDovL2xvY2FsaG9zdDozMDAwL3VzZXJzL2F1dGgvY2xhdmUvY2FsbGJhY2siIElEPSJfNktkdzFNMkR2UGRVU2FDbEF2ZVdTX3ZrWkJFUWNPMTRRLVVOOWR4bWt2bW1xX3IzdFRTSXpZeUlxdzE5alFpIiBJblJlc3BvbnNlVG89Il9lMmYzODUxZC1mNGY4LTRiZjEtOGU5Ny0yNDFlYzA1NjI5NWUiIElzc3VlSW5zdGFudD0iMjAyMi0wNy0yMVQxNDo0OTo1OS43MTNaIiBWZXJzaW9uPSIyLjAiPjxzYW1sMjpJc3N1ZXIgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6bmFtZWlkLWZvcm1hdDplbnRpdHkiPmh0dHBzOi8vc2UtcGFzYXJlbGEuY2xhdmUuZ29iLmVzPC9zYW1sMjpJc3N1ZXI+PGRzOlNpZ25hdHVyZSB4bWxuczpkcz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PGRzOlNpZ25lZEluZm8+PGRzOkNhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzEwL3htbC1leGMtYzE0biMiLz48ZHM6U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTUxMiIvPjxkczpSZWZlcmVuY2UgVVJJPSIjXzZLZHcxTTJEdlBkVVNhQ2xBdmVXU192a1pCRVFjTzE0US1VTjlkeG1rdm1tcV9yM3RUU0l6WXlJcXcxOWpRaSI+PGRzOlRyYW5zZm9ybXM+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIi8+PGRzOlRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyI+PGVjOkluY2x1c2l2ZU5hbWVzcGFjZXMgeG1sbnM6ZWM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvMTAveG1sLWV4Yy1jMTRuIyIgUHJlZml4TGlzdD0iZWlkYXMtbmF0dXJhbCB4cyIvPjwvZHM6VHJhbnNmb3JtPjwvZHM6VHJhbnNmb3Jtcz48ZHM6RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjc2hhNTEyIi8+PGRzOkRpZ2VzdFZhbHVlPjhWVUFHVE9Kb2pNN2lKS3B2TEY2aE5zYUYzMkFaMWpwSHplQVlJWW9aRDQxcFJTa0VFckRNSXBWUnFubTFONGFPaTRSaUxGOTJPbUYwcXRDNHpMVk5BPT08L2RzOkRpZ2VzdFZhbHVlPjwvZHM6UmVmZXJlbmNlPjwvZHM6U2lnbmVkSW5mbz48ZHM6U2lnbmF0dXJlVmFsdWU+TFRvOUN5cm84c0FnQmdxVEw1ZFZhd2FTNTRpaU9ESGVUZmNpV3hLa05nL3lDQVk1YTlWQy9uOXBxR0tFWVplaGdVMmQ3ZW9Gb3NpL04yQVlwcmttWFZUcnhZdlhBaUljUEdxNWxUMXo4OHFFb05xb3pHbXptL1ZzMmwrTWlvbk5SRHZZYUZWVzVucUl5T1YzZGo4Mi8zdHM3ekMraUNCNW1KcWNXWW9PaDkxeS81d0Y1VTBPdmozR01DS1pzYjZGSE03UkM5S1NGWVh0anBBMmlock9tbEc4STd0RVMrRmNQOGdPZXptWDhuK3VldFJNaFh4MkM5NWo2V3pRTitaeDNGZGZIVGY1QzBPTnVLbHR0SlM1dDNQcG5CWUcxTng4bVhNeHRqZWIwNzBLSVlOOHJ3TkpZOU9wQlF4dDFjQno5eGoxOStjd3FJZEF2K2pCWnU5WEtRPT08L2RzOlNpZ25hdHVyZVZhbHVlPjxkczpLZXlJbmZvPjxkczpYNTA5RGF0YT48ZHM6WDUwOUNlcnRpZmljYXRlPk1JSUhyakNDQnBhZ0F3SUJBZ0lRZnQ3KzBkZUFrNUpoRlFsUkJQSzluakFOQmdrcWhraUc5dzBCQVFzRkFEQkhNUXN3Q1FZRFZRUUcKRXdKRlV6RVJNQThHQTFVRUNnd0lSazVOVkMxU1EwMHhKVEFqQmdOVkJBc01IRUZESUVOdmJYQnZibVZ1ZEdWeklFbHVabTl5YmNPaApkR2xqYjNNd0hoY05NakV3T0RFeU1URTBNekV6V2hjTk1qUXdPREV5TVRFME16RXlXakNCN0RFTE1Ba0dBMVVFQmhNQ1JWTXhEekFOCkJnTlZCQWNNQmsxQlJGSkpSREZDTUVBR0ExVUVDZ3c1VFVsT1NWTlVSVkpKVHlCRVJTQkJVMVZPVkU5VElFVkRUMDVQVFVsRFQxTWcKV1NCVVVrRk9VMFpQVWsxQlEwbFBUaUJFU1VkSlZFRk1NVFV3TXdZRFZRUUxEQ3hUUlVOU1JWUkJVa2xCSUVkRlRrVlNRVXdnUkVVZwpRVVJOU1U1SlUxUlNRVU5KVDA0Z1JFbEhTVlJCVERFU01CQUdBMVVFQlJNSlV6STRNREExTmpoRU1SZ3dGZ1lEVlFSaERBOVdRVlJGClV5MVRNamd3TURVMk9FUXhJekFoQmdOVkJBTU1HbE5GVEV4UElFVk9WRWxFUVVRZ1UwZEJSQ0JRVWxWRlFrRlRNSUlCSWpBTkJna3EKaGtpRzl3MEJBUUVGQUFPQ0FROEFNSUlCQ2dLQ0FRRUF2ZE9CL21SS3pGSlNaS2JEckJ2Wm9vbW8rWXVjK0lLcjl1aVlJUnZUZ3oreQpFcXVjVlJlalJoTWpzSWgxTWlUMUdsUmIrVjlpU1Q2cFJqN3QvYVM4SDZTcXppekl5NzU2VGdzSno4R1ZSYk9mWDJBMVhDTjVRSzBGCm85NkhtY0FEVmowMU0xOHplK1ZRejdZRzBRL29uYmR4NUlad05uY3hPbjNlMGZHdzJURWI4NXd1eW5oQk5EM2NpMjM0MSt6aC96aGMKSEVkMHJNWHY2TkprVGkyRGlTNWFWeDgvb3U0TGpGdW05SG1GQnJJT2ZiVnY4citRNVcxcTQ5NEhsUnFHcS9yblR5R2lzcTNZQUMyaQpFRS9jdEpKZjg2ZHphL2IwOGxiOXlGVCtXQm1XNlpzNUFhM0N2STUrZG5HckVKay9PM3YrSmlCTWFEYU16a3dGWjhOa0NRSURBUUFCCm80SUQ3akNDQStvd0RBWURWUjBUQVFIL0JBSXdBRENCZ1FZSUt3WUJCUVVIQVFFRWRUQnpNRHNHQ0NzR0FRVUZCekFCaGk5b2RIUncKT2k4dmIyTnpjR052YlhBdVkyVnlkQzVtYm0xMExtVnpMMjlqYzNBdlQyTnpjRkpsYzNCdmJtUmxjakEwQmdnckJnRUZCUWN3QW9ZbwphSFIwY0RvdkwzZDNkeTVqWlhKMExtWnViWFF1WlhNdlkyVnlkSE12UVVORFQwMVFMbU55ZERDQ0FUUUdBMVVkSUFTQ0FTc3dnZ0VuCk1JSUJHQVlLS3dZQkJBR3NaZ01KRXpDQ0FRZ3dLUVlJS3dZQkJRVUhBZ0VXSFdoMGRIQTZMeTkzZDNjdVkyVnlkQzVtYm0xMExtVnoKTDJSd1kzTXZNSUhhQmdnckJnRUZCUWNDQWpDQnpReUJ5a05sY25ScFptbGpZV1J2SUdOMVlXeHBabWxqWVdSdklHUmxJSE5sYkd4dgpJR1ZzWldOMGNzT3pibWxqYnlCelpXZkR1bTRnY21WbmJHRnRaVzUwYnlCbGRYSnZjR1Z2SUdWSlJFRlRMaUJUZFdwbGRHOGdZU0JzCllYTWdZMjl1WkdsamFXOXVaWE1nWkdVZ2RYTnZJR1Y0Y0hWbGMzUmhjeUJsYmlCc1lTQkVVRU1nWkdVZ1JrNU5WQzFTUTAwZ1kyOXUKSUU1SlJqb2dVVEk0TWpZd01EUXRTaUFvUXk5S2IzSm5aU0JLZFdGdUlERXdOaTB5T0RBd09TMU5ZV1J5YVdRdFJYTndZY094WVNrdwpDUVlIQkFDTDdFQUJBVEE0QmdOVkhSRUVNVEF2cEMwd0t6RXBNQ2NHQ1NzR0FRUUJyR1lCQ0F3YVUwVk1URThnUlU1VVNVUkJSQ0JUClIwRkVJRkJTVlVWQ1FWTXdEZ1lEVlIwUEFRSC9CQVFEQWdYZ01CMEdBMVVkRGdRV0JCUi9XVm1wUkxhd2xIeGV3QzRsSnNxdEVnUUUKTnpDQnNBWUlLd1lCQlFVSEFRTUVnYU13Z2FBd0NBWUdCQUNPUmdFQk1Bc0dCZ1FBamtZQkF3SUJEekFUQmdZRUFJNUdBUVl3Q1FZSApCQUNPUmdFR0FqQnlCZ1lFQUk1R0FRVXdhREF5Rml4b2RIUndjem92TDNkM2R5NWpaWEowTG1adWJYUXVaWE12Y0dSekwxQkVVMTlEClQwMVFYMlZ6TG5Ca1poTUNaWE13TWhZc2FIUjBjSE02THk5M2QzY3VZMlZ5ZEM1bWJtMTBMbVZ6TDNCa2N5OVFSRk5mUTA5TlVGOWwKYmk1d1pHWVRBbVZ1TUI4R0ExVWRJd1FZTUJhQUZCbjRXQzhVMXFiTW13U1lDQTFNMTZzQXA0TmxNSUhnQmdOVkhSOEVnZGd3Z2RVdwpnZEtnZ2MrZ2djeUdnWjVzWkdGd09pOHZiR1JoY0dOdmJYQXVZMlZ5ZEM1bWJtMTBMbVZ6TDBOT1BVTlNUREVzVDFVOVFVTWxNakJECmIyMXdiMjVsYm5SbGN5VXlNRWx1Wm05eWJXRjBhV052Y3l4UFBVWk9UVlF0VWtOTkxFTTlSVk0vWTJWeWRHbG1hV05oZEdWU1pYWnYKWTJGMGFXOXVUR2x6ZER0aWFXNWhjbmsvWW1GelpUOXZZbXBsWTNSamJHRnpjejFqVWt4RWFYTjBjbWxpZFhScGIyNVFiMmx1ZElZcAphSFIwY0RvdkwzZDNkeTVqWlhKMExtWnViWFF1WlhNdlkzSnNjMk52YlhBdlExSk1NUzVqY213d0RRWUpLb1pJaHZjTkFRRUxCUUFECmdnRUJBQ1N5Tm5qM0tkMDVvQjdmU2NGaisyc3k1Q0t0SHJ5aUNJd3JsTEFHSFdTMHJpazIwV1NyeDEraGdrUkp4Z3NLdnFINW14RHoKZGRXZmc5MytOd0VQNkpDSFBNdFBxZldNYUxIR3VIUWZSWXhLSngwMGFrdWZoZ0gya25wQUVGSmhCNVNHRVUwZ1F1UlNpanZGNSthKwpWaFg5ZXZMdDNSd25HWUl3Y1BvMzRNVGxyK1BIUjdQVGd6akd4WW4vOGc4ZXRyT2VHZTNlWkFJcDBZTlREU1VBMUJMU2RoRGpNNnpQCjdEZFRPRkpHY2Z1M3BKQXgzRXB1RUJhU1FseXhjMkZXRHFXclA2eFBLZ3o1VmRxc0o0Wmxla2thMFNSSSt1Yi9kTlE0STQ0UGorcXMKMTVGV1NVRjNNdCtWQk5pemcyb21IcGRjY2NCMnhwZ0JzQk41azBHelQ1MD08L2RzOlg1MDlDZXJ0aWZpY2F0ZT48L2RzOlg1MDlEYXRhPjwvZHM6S2V5SW5mbz48L2RzOlNpZ25hdHVyZT48c2FtbDJwOlN0YXR1cz48c2FtbDJwOlN0YXR1c0NvZGUgVmFsdWU9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpzdGF0dXM6U3VjY2VzcyIvPjxzYW1sMnA6U3RhdHVzTWVzc2FnZT51cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6c3RhdHVzOlN1Y2Nlc3M8L3NhbWwycDpTdGF0dXNNZXNzYWdlPjwvc2FtbDJwOlN0YXR1cz48c2FtbDI6QXNzZXJ0aW9uIElEPSJfRlVGNFhNSDlILmVzUnJlNVZXZzloUlJ5ek91N19UYzFlRkdzVlZnRERuQzZlM0Njc1pZcG1QLTRvTjhjeFdqIiBJc3N1ZUluc3RhbnQ9IjIwMjItMDctMjFUMTQ6NDk6NTkuNzEzWiIgVmVyc2lvbj0iMi4wIj48c2FtbDI6SXNzdWVyIEZvcm1hdD0idXJuOm9hc2lzOm5hbWVzOnRjOlNBTUw6Mi4wOm5hbWVpZC1mb3JtYXQ6ZW50aXR5Ij5odHRwczovL3NlLXBhc2FyZWxhLmNsYXZlLmdvYi5lczwvc2FtbDI6SXNzdWVyPjxzYW1sMjpTdWJqZWN0PjxzYW1sMjpOYW1lSUQgRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6bmFtZWlkLWZvcm1hdDp0cmFuc2llbnQiIE5hbWVRdWFsaWZpZXI9Imh0dHBzOi8vc2UtcGFzYXJlbGEuY2xhdmUuZ29iLmVzIj40MDQ0NzA2Mks8L3NhbWwyOk5hbWVJRD48c2FtbDI6U3ViamVjdENvbmZpcm1hdGlvbiBNZXRob2Q9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDpjbTpiZWFyZXIiPjxzYW1sMjpTdWJqZWN0Q29uZmlybWF0aW9uRGF0YSBBZGRyZXNzPSIxMC4yNTIuMTMxLjIxIiBJblJlc3BvbnNlVG89Il9lMmYzODUxZC1mNGY4LTRiZjEtOGU5Ny0yNDFlYzA1NjI5NWUiIE5vdE9uT3JBZnRlcj0iMjAyMi0wNy0yMVQxNTowNDo1OS43MTNaIiBSZWNpcGllbnQ9Imh0dHA6Ly9sb2NhbGhvc3Q6MzAwMC91c2Vycy9hdXRoL2NsYXZlL2NhbGxiYWNrIi8+PC9zYW1sMjpTdWJqZWN0Q29uZmlybWF0aW9uPjwvc2FtbDI6U3ViamVjdD48c2FtbDI6Q29uZGl0aW9ucyBOb3RCZWZvcmU9IjIwMjItMDctMjFUMTQ6NDk6NTkuNzEzWiIgTm90T25PckFmdGVyPSIyMDIyLTA3LTIxVDE1OjA0OjU5LjcxM1oiPjxzYW1sMjpBdWRpZW5jZVJlc3RyaWN0aW9uPjxzYW1sMjpBdWRpZW5jZT5odHRwOi8vbG9jYWxob3N0OjMwMDAvdXNlcnMvYXV0aC9jbGF2ZS9jYWxsYmFjazwvc2FtbDI6QXVkaWVuY2U+PC9zYW1sMjpBdWRpZW5jZVJlc3RyaWN0aW9uPjxzYW1sMjpPbmVUaW1lVXNlLz48L3NhbWwyOkNvbmRpdGlvbnM+PHNhbWwyOkF1dGhuU3RhdGVtZW50IEF1dGhuSW5zdGFudD0iMjAyMi0wNy0yMVQxNDo0OTo1OS43MTNaIj48c2FtbDI6QXV0aG5Db250ZXh0PjxzYW1sMjpBdXRobkNvbnRleHRDbGFzc1JlZj5odHRwOi8vZWlkYXMuZXVyb3BhLmV1L0xvQS9zdWJzdGFudGlhbDwvc2FtbDI6QXV0aG5Db250ZXh0Q2xhc3NSZWY+PHNhbWwyOkF1dGhuQ29udGV4dERlY2wvPjwvc2FtbDI6QXV0aG5Db250ZXh0Pjwvc2FtbDI6QXV0aG5TdGF0ZW1lbnQ+PHNhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudD48c2FtbDI6QXR0cmlidXRlIEZyaWVuZGx5TmFtZT0iRmFtaWx5TmFtZSIgTmFtZT0iaHR0cDovL2VpZGFzLmV1cm9wYS5ldS9hdHRyaWJ1dGVzL25hdHVyYWxwZXJzb24vQ3VycmVudEZhbWlseU5hbWUiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6dXJpIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9ImVpZGFzLW5hdHVyYWw6Q3VycmVudEZhbWlseU5hbWVUeXBlIj5IRVJOQU5ERVogVkFMTFM8L3NhbWwyOkF0dHJpYnV0ZVZhbHVlPjwvc2FtbDI6QXR0cmlidXRlPjxzYW1sMjpBdHRyaWJ1dGUgRnJpZW5kbHlOYW1lPSJGaXJzdE5hbWUiIE5hbWU9Imh0dHA6Ly9laWRhcy5ldXJvcGEuZXUvYXR0cmlidXRlcy9uYXR1cmFscGVyc29uL0N1cnJlbnRHaXZlbk5hbWUiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6dXJpIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9ImVpZGFzLW5hdHVyYWw6Q3VycmVudEdpdmVuTmFtZVR5cGUiPk9MSVZFUjwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBGcmllbmRseU5hbWU9IlBlcnNvbklkZW50aWZpZXIiIE5hbWU9Imh0dHA6Ly9laWRhcy5ldXJvcGEuZXUvYXR0cmlidXRlcy9uYXR1cmFscGVyc29uL1BlcnNvbklkZW50aWZpZXIiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6dXJpIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9ImVpZGFzLW5hdHVyYWw6UGVyc29uSWRlbnRpZmllclR5cGUiPjQwNDQ3MDYySzwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBGcmllbmRseU5hbWU9IkZpcnN0U3VybmFtZSIgTmFtZT0iaHR0cDovL2VzLm1pbmhhZnAuY2xhdmUvRmlyc3RTdXJuYW1lIiBOYW1lRm9ybWF0PSJ1cm46b2FzaXM6bmFtZXM6dGM6U0FNTDoyLjA6YXR0cm5hbWUtZm9ybWF0OnVyaSI+PHNhbWwyOkF0dHJpYnV0ZVZhbHVlIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTp0eXBlPSJ4czpzdHJpbmciPkhFUk5BTkRFWjwvc2FtbDI6QXR0cmlidXRlVmFsdWU+PC9zYW1sMjpBdHRyaWJ1dGU+PHNhbWwyOkF0dHJpYnV0ZSBGcmllbmRseU5hbWU9IlBhcnRpYWxBZmlybWEiIE5hbWU9Imh0dHA6Ly9lcy5taW5oYWZwLmNsYXZlL1BhcnRpYWxBZmlybWEiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6dXJpIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9InhzOnN0cmluZyI+UEZCaGNuUnBZV3hmUVdacGNtMWhYMUpsYzNCdmJuTmxJSGh0Ykc1ek9tRm1lSEE5SW5WeWJqcGhabWx5YldFNlpITnpPakV1TURwd2NtOW1hV3hsT2xoVFV6cHpZMmhsYldFaUlIaHRiRzV6T21SemN6MGlkWEp1T205aGMybHpPbTVoYldWek9uUmpPbVJ6Y3pveExqQTZZMjl5WlRwelkyaGxiV0VpUGp4a2MzTTZVbVZ6ZFd4MFBqeGtjM002VW1WemRXeDBUV0ZxYjNJK2RYSnVPbTloYzJsek9tNWhiV1Z6T25Sak9tUnpjem94TGpBNmNtVnpkV3gwYldGcWIzSTZVM1ZqWTJWemN6d3ZaSE56T2xKbGMzVnNkRTFoYW05eVBqeGtjM002VW1WemRXeDBUV2x1YjNJK2RYSnVPbTloYzJsek9tNWhiV1Z6T25Sak9tUnpjem94TGpBNmNISnZabWxzWlhNNldGTlRPbkpsYzNWc2RHMXBibTl5T25aaGJHbGtPbU5sY25ScFptbGpZWFJsT2tSbFptbHVhWFJwZG1VOEwyUnpjenBTWlhOMWJIUk5hVzV2Y2o0OFpITnpPbEpsYzNWc2RFMWxjM05oWjJVZ2VHMXNPbXhoYm1jOUltVnpJajVGYkNCalpYSjBhV1pwWTJGa2J5QmxjeUIydzZGc2FXUnZQQzlrYzNNNlVtVnpkV3gwVFdWemMyRm5aVDQ4TDJSemN6cFNaWE4xYkhRK1BHRm1lSEE2VW1WaFpHRmliR1ZEWlhKMGFXWnBZMkYwWlVsdVptOCtQR0ZtZUhBNlVtVmhaR0ZpYkdWR2FXVnNaRDQ4WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UGtGd1pXeHNhV1J2YzFKbGMzQnZibk5oWW14bFBDOWhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytQR0ZtZUhBNlJtbGxiR1JXWVd4MVpUNUlSVkpPUVU1RVJWb2dWa0ZNVEZNOEwyRm1lSEE2Um1sbGJHUldZV3gxWlQ0OEwyRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrYm5WdFpYSnZVMlZ5YVdVOEwyRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNDhZV1o0Y0RwR2FXVnNaRlpoYkhWbFBqRXdNRE15TlRZek5qQXdPRE01TWpBeU9UQTVOamsxTVRBeE9EVXpNRGd3TmpnMU1qZ3lOand2WVdaNGNEcEdhV1ZzWkZaaGJIVmxQand2WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BHRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNTJZV3hwWkc5SVlYTjBZVHd2WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UGp4aFpuaHdPa1pwWld4a1ZtRnNkV1UrTWpBeU5TMHhNaTB4TUNCdGFjT3BJREUzT2pRMU9qVTBJQ3N3TVRBd1BDOWhabmh3T2tacFpXeGtWbUZzZFdVK1BDOWhabmh3T2xKbFlXUmhZbXhsUm1sbGJHUStQR0ZtZUhBNlVtVmhaR0ZpYkdWR2FXVnNaRDQ4WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UG5ObFozVnVaRzlCY0dWc2JHbGtiMUpsYzNCdmJuTmhZbXhsUEM5aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK1BHRm1lSEE2Um1sbGJHUldZV3gxWlQ1V1FVeE1Vend2WVdaNGNEcEdhV1ZzWkZaaGJIVmxQand2WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BHRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNXdjbWx0WlhKQmNHVnNiR2xrYjFKbGMzQnZibk5oWW14bFBDOWhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytQR0ZtZUhBNlJtbGxiR1JXWVd4MVpUNUlSVkpPUVU1RVJWbzhMMkZtZUhBNlJtbGxiR1JXWVd4MVpUNDhMMkZtZUhBNlVtVmhaR0ZpYkdWR2FXVnNaRDQ4WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK2MzVmlhbVZqZER3dllXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBqeGhabmh3T2tacFpXeGtWbUZzZFdVK1EwNDlUMHhKVmtWU0lFaEZVazVCVGtSRldpQldRVXhNVXlBdElFUk9TU0EwTURRME56QTJNa3NzYzJWeWFXRnNUblZ0WW1WeVBVbEVRMFZUTFRRd05EUTNNRFl5U3l4bmFYWmxiazVoYldVOVQweEpWa1ZTTEZOT1BVaEZVazVCVGtSRldpQldRVXhNVXl4RFBVVlRQQzloWm5od09rWnBaV3hrVm1Gc2RXVStQQzloWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBuVnpiME5sY25ScFptbGpZV1J2UEM5aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK1BHRm1lSEE2Um1sbGJHUldZV3gxWlQ1a2FXZHBkR0ZzVTJsbmJtRjBkWEpsSUh3Z2JtOXVVbVZ3ZFdScFlYUnBiMjRnZkNCclpYbEZibU5wY0dobGNtMWxiblE4TDJGbWVIQTZSbWxsYkdSV1lXeDFaVDQ4TDJGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBTWldGa1lXSnNaVVpwWld4a1BqeGhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytZMlZ5ZEZGMVlXeHBabWxsWkR3dllXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBqeGhabmh3T2tacFpXeGtWbUZzZFdVK1dVVlRQQzloWm5od09rWnBaV3hrVm1Gc2RXVStQQzloWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBtbGtSVzFwYzI5eVBDOWhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytQR0ZtZUhBNlJtbGxiR1JXWVd4MVpUNURUajFGUXkxRGFYVjBZV1JoYm1saExFOVZQVk5sY25abGFYTWdVTU82WW14cFkzTWdaR1VnUTJWeWRHbG1hV05oWTJuRHN5eFBQVU5QVGxOUFVrTkpJRUZFVFVsT1NWTlVVa0ZEU1U4Z1QwSkZVbFJCSUVSRklFTkJWRUZNVlU1WlFTeERQVVZUUEM5aFpuaHdPa1pwWld4a1ZtRnNkV1UrUEM5aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BHRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwR2FXVnNaRWxrWlc1MGFYUjVQbU5sY25SRGJHRnpjMmxtYVdOaGRHbHZiand2WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UGp4aFpuaHdPa1pwWld4a1ZtRnNkV1UrUlZOSlJ6d3ZZV1o0Y0RwR2FXVnNaRlpoYkhWbFBqd3ZZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZSbWxsYkdSSlpHVnVkR2wwZVQ1T2IyMWljbVZCY0dWc2JHbGtiM05TWlhOd2IyNXpZV0pzWlR3dllXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBqeGhabmh3T2tacFpXeGtWbUZzZFdVK1QweEpWa1ZTSUVoRlVrNUJUa1JGV2lCV1FVeE1Vend2WVdaNGNEcEdhV1ZzWkZaaGJIVmxQand2WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BHRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNUpSRjlsZFhKdmNHVnZQQzloWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrUEdGbWVIQTZSbWxsYkdSV1lXeDFaVDVKUkVORlV5MDBNRFEwTnpBMk1rczhMMkZtZUhBNlJtbGxiR1JXWVd4MVpUNDhMMkZtZUhBNlVtVmhaR0ZpYkdWR2FXVnNaRDQ4WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK2NHRnBjend2WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UGp4aFpuaHdPa1pwWld4a1ZtRnNkV1UrUlZNOEwyRm1lSEE2Um1sbGJHUldZV3gxWlQ0OEwyRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrY0c5c2FYUnBZMkU4TDJGbWVIQTZSbWxsYkdSSlpHVnVkR2wwZVQ0OFlXWjRjRHBHYVdWc1pGWmhiSFZsUGpFdU15NDJMakV1TkM0eExqRTFNRGsyTGpFdU15NHlMamcyTGpJc01DNDBMakF1TVRrME1URXlMakV1TUR3dllXWjRjRHBHYVdWc1pGWmhiSFZsUGp3dllXWjRjRHBTWldGa1lXSnNaVVpwWld4a1BqeGhabmh3T2xKbFlXUmhZbXhsUm1sbGJHUStQR0ZtZUhBNlJtbGxiR1JKWkdWdWRHbDBlVDV1YjIxaWNtVlNaWE53YjI1ellXSnNaVHd2WVdaNGNEcEdhV1ZzWkVsa1pXNTBhWFI1UGp4aFpuaHdPa1pwWld4a1ZtRnNkV1UrVDB4SlZrVlNQQzloWm5od09rWnBaV3hrVm1Gc2RXVStQQzloWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBtVjRkR1Z1YzJsdmJsVnpiME5sY25ScFptbGpZV1J2UEM5aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK1BHRm1lSEE2Um1sbGJHUldZV3gxWlQ1TFpYbFFkWEp3YjNObFNXUWdNRG9nSUZSTVV5QlhaV0lnWTJ4cFpXNTBJR0YxZEdobGJuUnBZMkYwYVc5dUNrdGxlVkIxY25CdmMyVkpaQ0F4T2lBZ1JTMXRZV2xzSUhCeWIzUmxZM1JwYjI0OEwyRm1lSEE2Um1sbGJHUldZV3gxWlQ0OEwyRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrZG1WeWMybHZibEJ2YkdsMGFXTmhQQzloWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrUEdGbWVIQTZSbWxsYkdSV1lXeDFaVDR4TVRJOEwyRm1lSEE2Um1sbGJHUldZV3gxWlQ0OEwyRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrY1hOalpEd3ZZV1o0Y0RwR2FXVnNaRWxrWlc1MGFYUjVQanhoWm5od09rWnBaV3hrVm1Gc2RXVStUazg4TDJGbWVIQTZSbWxsYkdSV1lXeDFaVDQ4TDJGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBTWldGa1lXSnNaVVpwWld4a1BqeGhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytUa2xHVW1WemNHOXVjMkZpYkdVOEwyRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNDhZV1o0Y0RwR2FXVnNaRlpoYkhWbFBqUXdORFEzTURZeVN6d3ZZV1o0Y0RwR2FXVnNaRlpoYkhWbFBqd3ZZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZSbWxsYkdSSlpHVnVkR2wwZVQ1UGNtZGhibWw2WVdOcGIyNUZiV2x6YjNKaFBDOWhabmh3T2tacFpXeGtTV1JsYm5ScGRIaytQR0ZtZUhBNlJtbGxiR1JXWVd4MVpUNURUMDVUVDFKRFNTQkJSRTFKVGtsVFZGSkJRMGxQSUU5Q1JWSlVRU0JFUlNCRFFWUkJURlZPV1VFOEwyRm1lSEE2Um1sbGJHUldZV3gxWlQ0OEwyRm1lSEE2VW1WaFpHRmliR1ZHYVdWc1pENDhZV1o0Y0RwU1pXRmtZV0pzWlVacFpXeGtQanhoWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrWTJ4aGMybG1hV05oWTJsdmJqd3ZZV1o0Y0RwR2FXVnNaRWxrWlc1MGFYUjVQanhoWm5od09rWnBaV3hrVm1Gc2RXVStNRHd2WVdaNGNEcEdhV1ZzWkZaaGJIVmxQand2WVdaNGNEcFNaV0ZrWVdKc1pVWnBaV3hrUGp4aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BHRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNTBhWEJ2UTJWeWRHbG1hV05oWkc4OEwyRm1lSEE2Um1sbGJHUkpaR1Z1ZEdsMGVUNDhZV1o0Y0RwR2FXVnNaRlpoYkhWbFBrTkJWRU5GVWxRZ1EwbFZWRUZFUVU1SlFTQlFSaUJEVUVsVFFTMHlQQzloWm5od09rWnBaV3hrVm1Gc2RXVStQQzloWm5od09sSmxZV1JoWW14bFJtbGxiR1ErUEdGbWVIQTZVbVZoWkdGaWJHVkdhV1ZzWkQ0OFlXWjRjRHBHYVdWc1pFbGtaVzUwYVhSNVBuWmhiR2xrYjBSbGMyUmxQQzloWm5od09rWnBaV3hrU1dSbGJuUnBkSGsrUEdGbWVIQTZSbWxsYkdSV1lXeDFaVDR5TURJeExURXlMVEV3SUhacFpTQXhOem8wTlRvMU5TQXJNREV3TUR3dllXWjRjRHBHYVdWc1pGWmhiSFZsUGp3dllXWjRjRHBTWldGa1lXSnNaVVpwWld4a1BqeGhabmh3T2xKbFlXUmhZbXhsUm1sbGJHUStQR0ZtZUhBNlJtbGxiR1JKWkdWdWRHbDBlVDVwWkZCdmJHbDBhV05oUEM5aFpuaHdPa1pwWld4a1NXUmxiblJwZEhrK1BHRm1lSEE2Um1sbGJHUldZV3gxWlQ1RVJVWkJWVXhVUEM5aFpuaHdPa1pwWld4a1ZtRnNkV1UrUEM5aFpuaHdPbEpsWVdSaFlteGxSbWxsYkdRK1BDOWhabmh3T2xKbFlXUmhZbXhsUTJWeWRHbG1hV05oZEdWSmJtWnZQand2VUdGeWRHbGhiRjlCWm1seWJXRmZVbVZ6Y0c5dWMyVSs8L3NhbWwyOkF0dHJpYnV0ZVZhbHVlPjwvc2FtbDI6QXR0cmlidXRlPjxzYW1sMjpBdHRyaWJ1dGUgRnJpZW5kbHlOYW1lPSJTZWxlY3RlZElkUCIgTmFtZT0iaHR0cDovL2VzLm1pbmhhZnAuY2xhdmUvU2VsZWN0ZWRJZFAiIE5hbWVGb3JtYXQ9InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphdHRybmFtZS1mb3JtYXQ6dXJpIj48c2FtbDI6QXR0cmlidXRlVmFsdWUgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnR5cGU9InhzOnN0cmluZyI+QUZJUk1BPC9zYW1sMjpBdHRyaWJ1dGVWYWx1ZT48L3NhbWwyOkF0dHJpYnV0ZT48L3NhbWwyOkF0dHJpYnV0ZVN0YXRlbWVudD48L3NhbWwyOkFzc2VydGlvbj48L3NhbWwycDpSZXNwb25zZT4="
    # rubocop: enable Layout/LineLength
  end

  let(:uid) { { "identifier" => "40447062K" } }
  let(:info) do
    {
      "email" => nil,
      "first_name" => "OLIVER",
      "first_surname" => "HERNANDEZ",
      "last_name" => "HERNANDEZ VALLS",
      "name" => "OLIVER HERNANDEZ VALLS",
      "nickname" => "oliver_hernandez_valls"
    }
  end

  before do
    OmniAuth.config.full_host = "http://localhost:3000"
    allow(strategy).to receive(:session).and_return({})
    Rails.application.secrets.omniauth[:clave] = {
      enabled: true,
      sp_entity_id: "S000000E_E00000000;SPTestApp",
      idp_sso_service_url: "https://clave.example.es",
      sp_certificate: File.read("spec/fixtures/sp_certificate.crt"),
      sp_private_key: File.read("spec/fixtures/sp_private_key.pem"),
      idp_certificate: File.read("spec/fixtures/idp_cert.cer")
    }
    strategy.options[:allowed_clock_drift] = 10.years
    Decidim::Clave.setup_clave_env(env)
  end

  it "has correct name" do
    expect(strategy.options.name).to eq("clave")
  end

  it "has correct args" do
    expect(strategy.class.args).to eq([:client_id, :client_secret, :idp_sso_service_url])
  end

  it "has correct site" do
    expect(strategy.options.idp_sso_service_url).to eq("https://clave.example.es")
  end

  it "has correct form" do
    expect(strategy.options[:form]).to be_a(Decidim::Clave::ClaveAutosubmitForm)
  end

  describe "callback_call" do
    let(:auth_hash) { subject.third.first }

    describe "uid" do
      it "returns the identifier" do
        expect(auth_hash.uid).to eq(uid["identifier"])
      end
    end

    describe "info" do
      it "returns the set of info fields" do
        expect(auth_hash.info).to eq(info)
      end
    end

    describe "#callback_url" do
      before do
        allow(strategy).to receive_messages(script_name: "", query_string: "")
      end

      it "is a combination of host, script name, and callback path" do
        expect(strategy.callback_url).to eq("http://localhost:3000/users/auth/clave/callback")
      end
    end

    it "parses response" do
      travel_to(Time.parse("2022-07-21T15:04:59.713Z")) do
        expect(subject.first).to eq(200)
        expect(subject.last.first.extra.response_object.errors).to be_empty
      end
    end
  end
end
# rubocop: enable Metrics/BlockLength
