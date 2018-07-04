/**
 * Registry.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.VORegistry.v0_3;

public class Registry  extends net.ivoa.www.xml.VOResource.v0_10.Service  implements java.io.Serializable {
    private java.lang.String[] managedAuthority;

    public Registry() {
    }


    /**
     * Gets the managedAuthority value for this Registry.
     * 
     * @return managedAuthority
     */
    public java.lang.String[] getManagedAuthority() {
        return managedAuthority;
    }


    /**
     * Sets the managedAuthority value for this Registry.
     * 
     * @param managedAuthority
     */
    public void setManagedAuthority(java.lang.String[] managedAuthority) {
        this.managedAuthority = managedAuthority;
    }

    public java.lang.String getManagedAuthority(int i) {
        return this.managedAuthority[i];
    }

    public void setManagedAuthority(int i, java.lang.String value) {
        this.managedAuthority[i] = value;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Registry)) return false;
        Registry other = (Registry) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = super.equals(obj) && 
            ((this.managedAuthority==null && other.getManagedAuthority()==null) || 
             (this.managedAuthority!=null &&
              java.util.Arrays.equals(this.managedAuthority, other.getManagedAuthority())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = super.hashCode();
        if (getManagedAuthority() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getManagedAuthority());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getManagedAuthority(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Registry.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "Registry"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("managedAuthority");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/VORegistry/v0.3", "managedAuthority"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
