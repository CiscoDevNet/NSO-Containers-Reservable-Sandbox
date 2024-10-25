# Adding NEDs

Place your NEDs inside this directory in the `*signed.bin` file format, for example `ncs-6.2.3-cisco-ios-6.106.5.signed.bin`.

The [setup_add_neds.sh script](../scripts/setup_add_neds.sh) automatically unpacks and adds the NEDs to the Docker image.

If you are using these NEDs for your own package, don't forget to update the `Makefile` of your package. See, for example, the Makefile of the [router package.](../packages/router/src/Makefile#L14)
